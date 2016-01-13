package hall.john.ksp.mainframe.orbit;

import org.apache.commons.math3.util.MathUtils;

import hall.john.ksp.mainframe.Body;

public class Orbit {
	protected Body _body;
	protected double _a;
	protected double _e;
	protected double _i; // radians
	protected double _lan; // radians
	protected double _aop; // radians

	public Orbit(Body body, double a, double e, double i, double lan, double aop) {
		_body = body;
		_a = a;
		_e = e;
		_i = i;
		_lan = lan;
		_aop = aop;
	}

	public Body getBody() {
		return _body;
	}

	public double getSemiMajorAxis() {
		return _a;
	}

	public double getSMA() {
		return _a;
	}

	public double getEccentricity() {
		return _e;
	}

	public double getApoapsis() {
		return _a * (1 + _e);
	}

	public double getPeriapsis() {
		return _a * (1 - _e);
	}

	public double getInclination() {
		return _i;
	}

	public double getLongitudeOfAscendingNode() {
		return _lan;
	}

	public double getLAN() {
		return _lan;
	}

	public double getArgumentOfPeriapsis() {
		return _aop;
	}

	public double getAOP() {
		return _aop;
	}

	public double getPeriod() {
		return MathUtils.TWO_PI * Math.sqrt((_a * _a * _a) / _body.getMu());
	}

	public double getMeanAngularMotion() {
		return MathUtils.TWO_PI / getPeriod();
	}

	public Orbit withApoapsis(double apo) { // including body radius
		double per = getPeriapsis();
		double a = (apo + per) / 2;
		double e = (apo - per) / (apo + per);
		return new Orbit(_body, a, e, _i, _lan, _aop);
	}

	public Orbit withPeriapsis(double per) { // including body radius
		double apo = getApoapsis();
		double a = (apo + per) / 2;
		double e = (apo - per) / (apo + per);
		return new Orbit(_body, a, e, _i, _lan, _aop);
	}

	public Orbit withSMA(double a) {
		return new Orbit(_body, a, _e, _i, _lan, _aop);
	}

	public Orbit withEccentricity(double e) {
		return new Orbit(_body, _a, e, _i, _lan, _aop);
	}

	public Orbit withInclination(double i) {
		return new Orbit(_body, _a, _e, i, _lan, _aop);
	}

	public Orbit withLAN(double lan) {
		return new Orbit(_body, _a, _e, _i, lan, _aop);
	}

	public Orbit withAOP(double aop) {
		return new Orbit(_body, _a, _e, _i, _lan, aop);
	}

	public OrbitAtTime withTrueAnomaly(double ta) {
		return new OrbitAtTime(this, ta);
	}
}
