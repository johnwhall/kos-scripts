package hall.john.ksp.mainframe.numericalmethods;

import java.util.function.DoubleFunction;

public class BrentsMethod {
	// Converted from https://alexmoon.github.io/ksp/javascripts/root.js

	public static double EPS = 1e-10;

	private DoubleFunction<Double> _f;
	private double _a;
	private double _b;
	private int _maxIter;
	private double _relAcc;
	private Double _result;
	private boolean _converged;

	public BrentsMethod(DoubleFunction<Double> f, double a, double b, int maxIter, double relAcc) {
		_f = f;
		_a = a;
		_b = b;
		_maxIter = maxIter;
		_relAcc = relAcc;
	}

	private int sign(double x) {
		if (x > 0) return 1;
		else if (x < 0) return -1;
		else return 0;
	}

	public void execute() {
		double a = _a;
		double b = _b;
		double fa = _f.apply(a);
		double fb = _f.apply(b);
		double c = a;
		double fc = fa;
		double d = b - a;
		double e = d;
		double relAcc = _relAcc + 0.5 * EPS;

		_converged = false;
		_result = null;

		if (sign(fa) == sign(fb)) {
			return;
		}

		int i = 0;
		while (true) {
			if (Math.abs(fc) < Math.abs(fb)) {
				a = b;
				b = c;
				c = a;
				fa = fb;
				fb = fc;
				fc = fa;
			}

			double tol = relAcc * Math.abs(b);
			double m = 0.5 * (c - b);

			if (Math.abs(fb) < EPS || Math.abs(m) <= tol) {
				_converged = true;
				_result = b;
			}

			if (i > _maxIter) {
				return;
			}

			if (Math.abs(e) < tol || Math.abs(fa) <= Math.abs(fb)) {
				d = m;
				e = m;
			} else {
				double s = fb / fa;
				double p = 2 * m * s;
				double q = 1 - s;
				if (a != c) {
					q = fa / fc;
					double r = fb / fc;
					p = s * (2 * m * q * (q - r) - (b - a) * (r - 1));
					q = (q - 1) * (r - 1) * (s - 1);
				}

				if (p > 0) {
					q = -q;
				} else {
					p = -p;
				}

				if (2 * p < Math.min(3 * m * q - Math.abs(tol * q), Math.abs(e * q))) {
					e = d;
					d = p / q;
				} else {
					d = m;
					e = m;
				}
			}

			a = b;
			fa = fb;
			if (Math.abs(d) > tol) {
				b = b + d;
			} else {
				double v = -tol;
				if (m > 0) v = tol;
				b = b + v;
			}

			fb = _f.apply(b);
			if ((fb < 0 && fc < 0) || (fb > 0 && fc > 0)) {
				c = a;
				fc = fa;
				d = b - a;
				e = b - a;
			}

			i++;
		}
	}

	public Double getResult() {
		return _result;
	}

	public boolean getConverged() {
		return _converged;
	}
}
