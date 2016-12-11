package hall.john.ksp.mainframe;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;
import org.apache.commons.math3.util.MathUtils;

import hall.john.ksp.mainframe.numericalmethods.BrentsMethod;

public class LambertSolver {
	// Converted from https://alexmoon.github.io/ksp/javascripts/lambert.js
	// Originally Based on Sun, F.T. "On the Minium Time Trajectory and Multiple
	// Solutions of Lambert's Problem"
	// AAS/AIAA Astrodynamics Conference, Provincetown, Massachusetts, AAS
	// 79-164, June 25-27, 1979

	public static double EPS = 1e-10;

	public static class Solution {
		public Vector3D v1;
		public Vector3D v2;
		public double angle;

		@Override
		public String toString() {
			StringBuilder strb = new StringBuilder();
			strb.append(v1);
			strb.append(" ");
			strb.append(v2);
			strb.append(" ");
			strb.append(angle);
			return strb.toString();
		}
	}

	// Provided
	private double _mu;
	private Vector3D _r1Vec;
	private Vector3D _r2Vec;
	private double _dt;
	private int _maxRevs;
	private boolean _prograde;

	// Calculated
	private double _sqrtMu;
	private double _invSqrtM;
	private double _invSqrtN;
	private double _c;
	private Vector3D _deltaPos;
	private double _r1;
	private double _r2;
	private double _transferAngle;
	private double _angleParameter;
	private double _angleParameter2;
	private double _angleParameter3;
	private double _parabolicNormalizedTime;
	private double _normalizedTime;
	private int _N;

	private List<Solution> _solutions;

	public LambertSolver(double mu, Vector3D r1Vec, Vector3D r2Vec, double dt, int maxRevs, boolean prograde) {
		_mu = mu;
		_r1Vec = r1Vec;
		_r2Vec = r2Vec;
		_dt = dt;
		_maxRevs = maxRevs;
		_prograde = prograde;
	}

	public double getMu() {
		return _mu;
	}

	public Vector3D getR1Vec() {
		return _r1Vec;
	}

	public Vector3D getR2Vec() {
		return _r2Vec;
	}

	public double getDT() {
		return _dt;
	}

	public int getMaxRevs() {
		return _maxRevs;
	}

	public boolean getPrograde() {
		return _prograde;
	}

	public List<Solution> getSolutions() {
		return _solutions;
	}

	private double acot(double x) {
		return 0.5 * Math.PI - Math.atan(x);
	}

	private double acoth(double x) {
		return 0.5 * Math.log((x + 1) / (x - 1));
	}

	private double fy(double x) {
		double y = Math.sqrt(1 - _angleParameter * _angleParameter * (1 - x * x));
		if (_angleParameter < 0) {
			return -y;
		} else {
			return y;
		}
	}

	private double ftau(double x) {
		if (x == 1) {
			return _parabolicNormalizedTime - _normalizedTime;
		} else {
			double y = fy(x);
			if (x > 1) {
				double g = Math.sqrt(x * x - 1);
				double h = Math.sqrt(y * y - 1);
				return (-acoth(x / g) + acoth(y / h) + x * g - y * h) / (g * g * g) - _normalizedTime;
			} else {
				double g = Math.sqrt(1 - x * x);
				double h = Math.sqrt(1 - y * y);
				return (acot(x / g) - Math.atan(h / y) - x * g + y * h + _N * Math.PI) / (g * g * g) - _normalizedTime;
			}
		}
	}

	private double phix(double x) {
		if (x == 0)
			x = EPS;
		if (x == 1)
			x = 1 - EPS;
		double g = Math.sqrt(1 - x * x);
		return acot(x / g) - (2 + x * x) * g / (3 * x);
	}

	private double phiy(double y) {
		if (y == 0)
			y = EPS;
		double h = Math.sqrt(1 - y * y);
		return Math.atan(h / y) - (2 + y * y) * h / (3 * y);
	}

	private void pushSolution(double x, double y, double N) {
		double vc = _sqrtMu * (y * _invSqrtN + x * _invSqrtM);
		double vr = _sqrtMu * (y * _invSqrtN - x * _invSqrtM);
		Vector3D ec = _deltaPos.scalarMultiply(vc / _c);
		Solution sol = new Solution();
		sol.v1 = ec.add(_r1Vec.scalarMultiply(vr / _r1));
		sol.v2 = ec.subtract(_r2Vec.scalarMultiply(vr / _r2));
		sol.angle = MathUtils.TWO_PI * N + _transferAngle;
		_solutions.add(sol);
	}

	private void pushIfConverges(BrentsMethod mth, int N) {
		mth.execute();
		if (mth.getConverged()) {
			pushSolution(mth.getResult(), fy(mth.getResult()), N);
		}
	}

	private double relativeError(double a, double b) {
		return Math.abs(1 - a / b);
	}

	public void solve() {
		_r1 = _r1Vec.getNorm();
		_r2 = _r2Vec.getNorm();
		_deltaPos = _r2Vec.subtract(_r1Vec);
		_c = _deltaPos.getNorm();
		double m = _r1 + _r2 + _c;
		double n = _r1 + _r2 - _c;

		_transferAngle = Vector3D.angle(_r1Vec, _r2Vec);
		int pro = _prograde ? 1 : 0;
		if ((_r1Vec.getX() * _r2Vec.getY() - _r1Vec.getY() * _r2Vec.getX()) * pro < 0) {
			_transferAngle = MathUtils.TWO_PI - _transferAngle;
		}

		_angleParameter = Math.sqrt(n / m);
		if (_transferAngle > Math.PI) {
			_angleParameter *= -1;
		}
		_angleParameter2 = _angleParameter * _angleParameter;
		_angleParameter3 = _angleParameter2 * _angleParameter;

		_normalizedTime = 4 * _dt * Math.sqrt(_mu / (m * m * m));
		_parabolicNormalizedTime = 2.0 / 3 * (1 - _angleParameter3);

		_N = 0;

		_sqrtMu = Math.sqrt(_mu);
		_invSqrtM = 1 / Math.sqrt(m);
		_invSqrtN = 1 / Math.sqrt(n);

		_solutions = new ArrayList<Solution>();

		if (relativeError(_normalizedTime, _parabolicNormalizedTime) < 1e-6) {
			double x = 1;
			double y = _angleParameter < 0 ? -1 : 1;
			pushSolution(x, y, 0);
		} else if (_normalizedTime < _parabolicNormalizedTime) {
			double x1 = 1;
			double x2 = 2;
			while (ftau(x2) >= 0) {
				x1 = x2;
				x2 = x2 * 2;
			}

			BrentsMethod mth = new BrentsMethod(this::ftau, x1, x2, 100, 1e-4);
			mth.execute();
			if (!mth.getConverged())
				throw new RuntimeException("failure");
			double x = mth.getResult();
			pushSolution(x, fy(x), _N);
		} else {
			int maxRevs = (int) Math.min(_maxRevs, Math.floor(_normalizedTime / Math.PI));
			double minimumEnergyNormalizedTime = Math.acos(_angleParameter)
					+ _angleParameter * Math.sqrt(1 - _angleParameter2);

			int i = 0;
			while (Math.abs(i) <= Math.abs(maxRevs)) {
				double minimumNormalizedTime = 0;
				double xMT = 0;

				if (_N > 0 && _N == maxRevs) {
					if (_angleParameter == 1) {
						xMT = 0;
						minimumNormalizedTime = minimumEnergyNormalizedTime;
					} else if (_angleParameter == 0) {
						BrentsMethod mth = new BrentsMethod(x -> phix(x) + _N * Math.PI, 0, 1, 100, 1e-4);
						mth.execute();
						if (!mth.getConverged())
							throw new RuntimeException("failure");
						xMT = mth.getResult();
						minimumNormalizedTime = 2 / (3 * xMT);
					} else {
						BrentsMethod mth = new BrentsMethod(x -> phix(x) - phiy(fy(x)) + _N * Math.PI, 0, 1, 100, 1e-4);
						mth.execute();
						if (!mth.getConverged())
							throw new RuntimeException("failure");
						xMT = mth.getResult();
						minimumNormalizedTime = (2 / 3.0) * (1 / xMT - _angleParameter3 / Math.abs(fy(xMT)));
					}

					if (relativeError(_normalizedTime, minimumNormalizedTime) < 1e-6) {
						pushSolution(xMT, fy(xMT), (_N + 1) * MathUtils.TWO_PI - _transferAngle);
						break;
					} else if (_normalizedTime < minimumNormalizedTime) {
						break;
					} else if (_normalizedTime < minimumEnergyNormalizedTime) {
						pushIfConverges(new BrentsMethod(this::ftau, 0, xMT, 100, 1e-4), _N);
						pushIfConverges(new BrentsMethod(this::ftau, xMT, 1 - EPS, 100, 1e-4), _N);
						break;
					}
				}

				if (relativeError(_normalizedTime, minimumEnergyNormalizedTime) < 1e-6) {
					pushSolution(0, fy(0), _N);
					if (_N > 0) {
						pushIfConverges(new BrentsMethod(this::ftau, 1e-6, 1 - EPS, 100, 1e-4), _N);
					}
				} else {
					if (_N > 0 || _normalizedTime > minimumEnergyNormalizedTime) {
						pushIfConverges(new BrentsMethod(this::ftau, -1 + EPS, 0, 100, 1e-4), _N);
					}
					if (_N > 0 || _normalizedTime < minimumEnergyNormalizedTime) {
						pushIfConverges(new BrentsMethod(this::ftau, 0, 1 - EPS, 100, 1e-4), _N);
					}
				}

				minimumEnergyNormalizedTime = minimumEnergyNormalizedTime + Math.PI;

				if (maxRevs >= 0) {
					i++;
				} else {
					i--;
				}
				_N = i;
			}
		}
	}

}
