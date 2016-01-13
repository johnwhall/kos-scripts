package hall.john.ksp.mainframe.numericalmethods;

import java.util.function.DoubleFunction;

public class NewtonsMethod {
	private DoubleFunction<Double> _f;
	private DoubleFunction<Double> _fp;
	private double _x0;
	private int _maxIter;
	private double _tol;
	private Double _result;
	private boolean _converged;

	public NewtonsMethod(DoubleFunction<Double> f, DoubleFunction<Double> fp, double x0, int maxIter, double tol) {
		_f = f;
		_fp = fp;
		_x0 = x0;
		_maxIter = maxIter;
		_tol = tol;
	}

	public void execute() {
		_converged = false;
		_result = null;

		double x = _x0;
		int iter = 1;

		while (true) {
			if (iter > _maxIter) {
				return;
			}

			double fx = _f.apply(x);
			if (Math.abs(fx) < _tol) {
				_converged = true;
				_result = x;
				return;
			}

			double fpx = _fp.apply(x);
			if (fpx == 0) {
				return;
			}

			x = x - fx / fpx;
			iter++;
		}
	}

	public Double getResult() {
		return _result;
	}

	public boolean getConverged() {
		return _converged;
	}
}
