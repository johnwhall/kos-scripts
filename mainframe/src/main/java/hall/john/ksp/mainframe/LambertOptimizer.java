package hall.john.ksp.mainframe;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;

import hall.john.ksp.mainframe.LambertSolver.Solution;
import hall.john.ksp.mainframe.orbit.ManeuverNode;
import hall.john.ksp.mainframe.orbit.OrbitAtTime;

public class LambertOptimizer {
	// Provided
	private double _mu;
	private OrbitAtTime _tgtOat0;
	private OrbitAtTime _oat0;
	private double _tMin;
	private double _tMax;
	private double _tStep;
	private double _dtMin;
	private double _dtMax;
	private double _dtStep;
	private boolean _allowLob;
	private boolean _optArrival;

	// Calculated
	private Candidate _best;
	private long _count;
	private long _numTCalcs;
	private long _numDTCalcs;

	private static int NUM_THREADS = 8;

	public LambertOptimizer(double mu, OrbitAtTime oat0, OrbitAtTime tgtOat0, double tMin, double tMax, double tStep,
			double dtMin, double dtMax, double dtStep, boolean allowLob, boolean optArrival) {
		_mu = mu;
		_tgtOat0 = tgtOat0;
		_oat0 = oat0;
		_tMin = tMin;
		_tMax = tMax;
		_tStep = tStep;
		_dtMin = dtMin;
		_dtMax = dtMax;
		_dtStep = dtStep;
		_allowLob = allowLob;
		_optArrival = optArrival;
		_numTCalcs = (long) ((_tMax - _tMin) / (_tStep)) + 1L;
		_numDTCalcs = (long) ((_dtMax - _dtMin) / (_dtStep)) + 1L;
	}

	private Candidate executeSingle(double t, double dt) {
		OrbitAtTime oatAtBurn1 = _oat0.afterTime(t);
		Vector3D r1 = oatAtBurn1.getRadiusVector();

		OrbitAtTime tgtOatAtIntercept = _tgtOat0.afterTime(t + dt);
		Vector3D r2 = tgtOatAtIntercept.getRadiusVector();

		LambertSolver ls = new LambertSolver(_mu, r1, r2, dt, 0, true);
		ls.solve();

		List<Solution> sols = ls.getSolutions();
		if (sols.isEmpty()) {
			return null;
		} else {
			Vector3D v1 = sols.get(0).v1;
			Vector3D v2 = sols.get(0).v2;

			Candidate candidate = new Candidate();
			candidate.dv1 = v1.subtract(oatAtBurn1.getVelocityVector());
			candidate.dv2 = tgtOatAtIntercept.getVelocityVector().subtract(v2);
			candidate.dv = candidate.dv1.getNorm();
			candidate.t = t;
			candidate.dt = dt;

			if (_optArrival) {
				candidate.dv += candidate.dv2.getNorm();
			}

			if (!_allowLob) {
				double a = 1 / ((2 / r1.getNorm()) - (v1.getNormSq() / _mu));
				Vector3D eVec = (v1.crossProduct(r1.crossProduct(v1))).scalarMultiply(1 / _mu).subtract(r1.normalize());
				double e = eVec.getNorm();
				double apoapsis = a * (1 + e);
				if (apoapsis > r2.getNorm())
					return null;
			}

			return candidate;
		}
	}

	public void execute() {
		ExecutorService executor = Executors.newFixedThreadPool(NUM_THREADS);

		for (int i = 0; i < NUM_THREADS; i++) {
			final int threadNum = i;
			Runnable run = () -> {
				long count = 0;
				Candidate best = null;
				for (long tIdx = threadNum; tIdx < _numTCalcs; tIdx += NUM_THREADS) {
					double t = _tMin + tIdx * _tStep;
					for (double dtIdx = 0; dtIdx < _numDTCalcs; dtIdx++) {
						double dt = _dtMin + dtIdx * _dtStep;
						Candidate candidate = executeSingle(t, dt);
						if (candidate != null) {
//							OrbitAtTime orbitAtBurn = _oat0.afterTime(t);
//							ManeuverNode node = new ManeuverNode(orbitAtBurn, candidate.dv1);
//							OrbitAtTime newOAT = node.getResultingOAT();
//							if (newOAT.getPeriapsis() < 6571000) {
//								continue;
//							}

//							OrbitAtTime orbitAtIntercept = newOAT.afterTime(dt);
//							OrbitAtTime targetAtIntercept = _tgtOat0.afterTime(t + dt);
//							Vector3D radiusAtIntercept = orbitAtIntercept.getRadiusVector();
//							Vector3D targetRadiusAtIntercept = targetAtIntercept.getRadiusVector();
//							double dist = targetRadiusAtIntercept.subtract(radiusAtIntercept).getNorm();

							if (best == null || candidate.dv < best.dv) {
								best = candidate;
							}
						}
						count++;
					}
				}

				synchronized (LambertOptimizer.this) {
					if (_best == null || best.dv < _best.dv) {
						_best = best;
					}
					_count += count;
				}
			};

			executor.execute(run);
		}

		try {
			executor.shutdown();
			executor.awaitTermination(Long.MAX_VALUE, TimeUnit.SECONDS);
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
	}

	public Vector3D getDV1() {
		return _best.dv1;
	}

	public Vector3D getDV2() {
		return _best.dv2;
	}

	public Double getT() {
		return _best.t;
	}

	public Double getDT() {
		return _best.dt;
	}

	public long getCount() {
		return _count;
	}

	public static Map<String, Object> mainframe(List<String> requestArgs) {
		double mu = Double.parseDouble(requestArgs.get(0));
		Body b = new Body("mfBody", mu);

		double rx1 = Double.parseDouble(requestArgs.get(1));
		double ry1 = Double.parseDouble(requestArgs.get(2));
		double rz1 = Double.parseDouble(requestArgs.get(3));
		Vector3D r1 = new Vector3D(rx1, ry1, rz1);

		double vx1 = Double.parseDouble(requestArgs.get(4));
		double vy1 = Double.parseDouble(requestArgs.get(5));
		double vz1 = Double.parseDouble(requestArgs.get(6));
		Vector3D v1 = new Vector3D(vx1, vy1, vz1);
		OrbitAtTime oat0 = new OrbitAtTime(b, r1, v1);

		double rx2 = Double.parseDouble(requestArgs.get(7));
		double ry2 = Double.parseDouble(requestArgs.get(8));
		double rz2 = Double.parseDouble(requestArgs.get(9));
		Vector3D r2 = new Vector3D(rx2, ry2, rz2);

		double vx2 = Double.parseDouble(requestArgs.get(10));
		double vy2 = Double.parseDouble(requestArgs.get(11));
		double vz2 = Double.parseDouble(requestArgs.get(12));
		Vector3D v2 = new Vector3D(vx2, vy2, vz2);
		OrbitAtTime tgtOat0 = new OrbitAtTime(b, r2, v2);

		double tMin = Double.parseDouble(requestArgs.get(13));
		double tMax = Double.parseDouble(requestArgs.get(14));
		double tStep = Double.parseDouble(requestArgs.get(15));

		double dtMin = Double.parseDouble(requestArgs.get(16));
		double dtMax = Double.parseDouble(requestArgs.get(17));
		double dtStep = Double.parseDouble(requestArgs.get(18));

		boolean allowLob = Boolean.parseBoolean(requestArgs.get(19));
		boolean optArrival = Boolean.parseBoolean(requestArgs.get(20));

		System.out.println("mu = " + mu);
		System.out.println("r1 = " + Utils.formatVector(r1));
		System.out.println("v1 = " + Utils.formatVector(v1));
		System.out.println("r2 = " + Utils.formatVector(r2));
		System.out.println("v2 = " + Utils.formatVector(v2));
		System.out.println("t: (min: " + tMin + " step: " + tStep + " max: " + tMax + ")");
		System.out.println("dt: (min: " + dtMin + " step: " + dtStep + " max: " + dtMax + ")");
		System.out.println("allowLob = " + allowLob);
		System.out.println("optArrival = " + optArrival);

		double initialPhaseAngle = Math.toDegrees(oat0.phaseAngleWith(tgtOat0));
		System.out.println("Initial Phase Angle: " + initialPhaseAngle + " degrees");

		LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep, allowLob,
				optArrival);
		lo.execute();

		Vector3D dv1 = lo.getDV1();
		Vector3D dv2 = lo.getDV2();
		double t = lo.getT();
		double dt = lo.getDT();

		System.out.println("dv1 = " + Utils.formatVector(dv1) + " (norm: " + dv1.getNorm() + ")");
		System.out.println("dv2 = " + Utils.formatVector(dv2) + " (norm: " + dv2.getNorm() + ")");
		System.out.println("t = " + t);
		System.out.println("dt = " + dt);

		OrbitAtTime orbitAtBurn = oat0.afterTime(t);
		OrbitAtTime targetAtBurn = tgtOat0.afterTime(t);
		System.out.println("radiusAtBurn = " + Utils.formatVector(orbitAtBurn.getRadiusVector()));
		System.out.println("targetRadiusAtBurn = " + Utils.formatVector(targetAtBurn.getRadiusVector()));

		ManeuverNode node = new ManeuverNode(orbitAtBurn, dv1);
		OrbitAtTime newOAT = node.getResultingOAT();
		OrbitAtTime orbitAtIntercept = newOAT.afterTime(dt);
		OrbitAtTime targetAtIntercept = tgtOat0.afterTime(t + dt);
		Vector3D radiusAtIntercept = orbitAtIntercept.getRadiusVector();
		Vector3D targetRadiusAtIntercept = targetAtIntercept.getRadiusVector();

		System.out.println("radiusAtIntercept = " + Utils.formatVector(radiusAtIntercept));
		System.out.println("targetRadiusAtIntercept = " + Utils.formatVector(targetRadiusAtIntercept));
		double dist = targetRadiusAtIntercept.subtract(radiusAtIntercept).getNorm();
		System.out.println("distance = " + dist);
		System.out.println("prograde = " + node.getPrograde());
		System.out.println("normal = " + node.getNormal());
		System.out.println("radial = " + node.getRadial());

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("t", t);
		result.put("dt", dt);
		result.put("prograde", node.getPrograde());
		result.put("normal", node.getNormal());
		result.put("radial", node.getRadial());
		return result;
	}

	private static class Candidate {
		public Vector3D dv1, dv2;
		public double t, dt, dv;
	}
}
