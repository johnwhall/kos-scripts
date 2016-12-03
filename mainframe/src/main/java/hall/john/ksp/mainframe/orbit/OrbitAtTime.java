package hall.john.ksp.mainframe.orbit;

import java.util.function.DoubleFunction;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;
import org.apache.commons.math3.util.MathUtils;

import hall.john.ksp.mainframe.Body;
import hall.john.ksp.mainframe.numericalmethods.NewtonsMethod;

public class OrbitAtTime extends Orbit {
	private Double _ta; // radians
	private Double _ea; // radians
	private Double _ma; // radians
	private Vector3D _rVec;
	private Vector3D _vVec;
	private Double _r;
	private Double _v;

	public OrbitAtTime(Body body, double a, double e, double i, double lan, double aop, double ta) {
		super(body, a, e, i, lan, aop);
		_ta = ta;
	}

	public OrbitAtTime(Orbit orbit, double ta) {
		this(orbit.getBody(), orbit._a, orbit._e, orbit._i, orbit._lan, orbit._aop, ta);
	}

	public OrbitAtTime(Body b, Vector3D rVec, Vector3D vVec) {
		this(fromECI(b, rVec, vVec));
	}

	public OrbitAtTime(OrbitAtTime other) {
		super(other.getBody(), other._a, other._e, other._i, other._lan, other._aop);
		_ta = other._ta;
		_ea = other._ea;
		_ma = other._ma;
		_rVec = other._rVec;
		_vVec = other._vVec;
		_r = other._r;
		_v = other._v;
	}

	private void calcTrueAnomaly() {
		if (_ta == null) {
			throw new RuntimeException("not yet implemented");
		}
	}

	public double getTrueAnomaly() {
		calcTrueAnomaly();
		return _ta;
	}

	private void calcEccentricAnomaly() {
		if (_ea == null) {
			calcTrueAnomaly();
			_ea = Math.acos((_e + Math.cos(_ta)) / (1 + _e * Math.cos(_ta)));
			if (Math.PI < _ta && _ta < MathUtils.TWO_PI)
				_ea = MathUtils.TWO_PI - _ea;
		}
	}

	public double getEccentricAnomaly() {
		calcEccentricAnomaly();
		return _ea;
	}

	private void calcMeanAnomaly() {
		if (_ma == null) {
			calcEccentricAnomaly();
			_ma = _ea - _e * Math.sin(_ea);
		}
	}

	public double getMeanAnomaly() {
		calcMeanAnomaly();
		return _ma;
	}

	private void calcECIVectors() {
		if (_ta == null)
			throw new RuntimeException("can't calc eci vecs without true anomaly");
		if (_rVec == null || _vVec == null) {
			double p = _a * (1 - _e * _e);
			double r = p / (1 + _e * Math.cos(_ta));
			double h = Math.sqrt(_body.getMu() * p);

			double coslan = Math.cos(_lan);
			double sinlan = Math.sin(_lan);
			double cosaopta = Math.cos(_aop + _ta);
			double sinaopta = Math.sin(_aop + _ta);
			double cosi = Math.cos(_i);
			double sini = Math.sin(_i);

			double x = r * (coslan * cosaopta - sinlan * sinaopta * cosi);
			double y = r * (sinlan * cosaopta + coslan * sinaopta * cosi);
			double z = r * (sini * sinaopta);

			_rVec = new Vector3D(x, y, z);

			double sinta = Math.sin(_ta);
			double herpsinta = h * _e * sinta / (r * p);
			double hr = h / r;

			double vx = x * herpsinta - hr * (coslan * sinaopta + sinlan * cosaopta * cosi);
			double vy = y * herpsinta - hr * (sinlan * sinaopta - coslan * cosaopta * cosi);
			double vz = z * herpsinta + hr * sini * cosaopta;

			_vVec = new Vector3D(vx, vy, vz);
		}
	}

	public Vector3D getRadiusVector() {
		calcECIVectors();
		return _rVec;
	}

	public Vector3D getVelocityVector() {
		calcECIVectors();
		return _vVec;
	}

	private void calcRadius() {
		if (_r == null) {
			calcECIVectors();
			_r = _rVec.getNorm();
		}
	}

	public double getRadius() {
		calcRadius();
		return _r;
	}

	private void calcVelocity() {
		if (_v == null) {
			calcECIVectors();
			_v = _vVec.getNorm();
		}
	}

	public double getVelocity() {
		calcVelocity();
		return _v;
	}

	public OrbitAtTime afterTime(double dt) {
		double ma = getMeanAnomaly();
		double n = getMeanAngularMotion();

		double newMA = (ma + n * dt) % MathUtils.TWO_PI;
		double newEA = eccentricAnomalyFromMeanAnomaly(_e, newMA);
		double newTA = 2 * Math.atan2(Math.sqrt(1 + _e) * Math.sin(newEA / 2), Math.sqrt(1 - _e) * Math.cos(newEA / 2));
		return new OrbitAtTime(_body, _a, _e, _i, _lan, _aop, newTA);
	}

	public double phaseAngleWith(OrbitAtTime oat) {
		return Vector3D.angle(_rVec, oat.getRadiusVector());
	}

	private static double eccentricAnomalyFromMeanAnomaly(double e, double ma) {
		if (Math.abs(e) < 1e-9) {
			return ma;
		}

		DoubleFunction<Double> f = (double x) -> x - e * Math.sin(x) - ma;
		DoubleFunction<Double> fp = (double x) -> 1 - e * Math.cos(x);
		NewtonsMethod mth = new NewtonsMethod(f, fp, ma, 100, 1e-9);
		mth.execute();
		if (!mth.getConverged())
			throw new RuntimeException("failed to converge");
		return mth.getResult();
	}

	private static OrbitAtTime fromECI(Body b, Vector3D rVec, Vector3D vVec) {
		double r = rVec.getNorm();
		double mu = b.getMu();

		// Semi-major Axis
		double a = 1 / ((2 / r) - (vVec.getNormSq() / b.getMu()));

		// Eccentricity
		Vector3D h = rVec.crossProduct(vVec);
		Vector3D eVec = vVec.crossProduct(h).scalarMultiply(1 / mu).subtract(rVec.normalize());
		double e = eVec.getNorm();

		// Inclination
		double i = Math.acos(h.getZ() / h.getNorm());

		// Longitude of Ascending Node
		Vector3D n = new Vector3D(-h.getY(), h.getX(), 0);
		double lan = 0;
		if (n.getNorm() != 0) {
			lan = Math.acos(n.getX() / n.getNorm());
			if (n.getY() < 0)
				lan = MathUtils.TWO_PI - lan;
		}

		// Argument of Periapsis
		double aop = 0;
		if (n.getNorm() != 0) {
			aop = Math.acos(n.dotProduct(eVec) / (n.getNorm() * e));
			if (eVec.getZ() < 0)
				aop = MathUtils.TWO_PI - aop;
		}

		// True Anomaly
		double ta = 0;
		if (Math.abs(e) > 1e-6) {
			ta = Math.acos(eVec.dotProduct(rVec) / (r * e));
			if (rVec.dotProduct(vVec) < 0)
				ta = MathUtils.TWO_PI - ta;
		} else if (Math.abs(i) > 1e-6) {
			// Circular orbit
			ta = Math.acos(n.dotProduct(rVec) / (r * n.getNorm()));
			if (n.dotProduct(vVec) > 0)
				ta = MathUtils.TWO_PI - ta;
		} else {
			// Circular orbit with zero inclination
			ta = Math.acos(rVec.getX() / r);
			if (vVec.getX() > 0)
				ta = MathUtils.TWO_PI - ta;
		}

		OrbitAtTime oat = new OrbitAtTime(b, a, e, i, lan, aop, ta);
		oat._rVec = rVec;
		oat._vVec = vVec;
		return oat;
	}

}
