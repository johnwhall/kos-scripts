package hall.john.ksp.mainframe.orbit;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;

public class ManeuverNode {
	private OrbitAtTime _oat;
	private Vector3D _dvVec;
	private Double _dv;
	private Double _prograde;
	private Double _normal;
	private Double _radial;

	public ManeuverNode(OrbitAtTime oat, Vector3D dvVec) {
		_oat = oat;
		_dvVec = dvVec;
	}

	public ManeuverNode(OrbitAtTime oat, double prograde, double normal, double radial) {
		_oat = oat;
		_prograde = prograde;
		_normal = normal;
		_radial = radial;
	}

	public OrbitAtTime getOAT() {
		return _oat;
	}

	private Vector3D proDir() {
		return _oat.getVelocityVector().normalize();
	}

	private Vector3D normDir() {
		return _oat.getRadiusVector().crossProduct(_oat.getVelocityVector()).normalize();
	}

	private Vector3D radialDir() {
		return _oat.getVelocityVector().crossProduct(normDir()).normalize();
	}

	private void calcDVVec() {
		if (_dvVec == null) {
			if (_prograde == null || _normal == null || _radial == null) throw new RuntimeException("need pnr to calc dvVec");
			Vector3D pro = proDir().scalarMultiply(_prograde);
			Vector3D norm = normDir().scalarMultiply(_normal);
			Vector3D rad = radialDir().scalarMultiply(_radial);
			_dvVec = pro.add(norm).add(rad);
		}
	}

	public Vector3D getDVVec() {
		calcDVVec();
		return _dvVec;
	}

	public double getDV() {
		if (_dv == null) {
			calcDVVec();
			_dv = _dvVec.getNorm();
		}
		return _dv;
	}

	public double getPrograde() {
		if (_prograde == null) {
			if (_dvVec == null) throw new RuntimeException("need dvVec to calc prograde");
			_prograde = projectionOnto(_dvVec, proDir());
		}

		return _prograde;
	}

	public double getNormal() {
		if (_normal == null) {
			if (_dvVec == null) throw new RuntimeException("need dvVec to calc normal");
			_normal = projectionOnto(_dvVec, normDir());
		}

		return _normal;
	}

	public double getRadial() {
		if (_radial == null) {
			if (_dvVec == null) throw new RuntimeException("need dvVec to calc radial");
			_radial = projectionOnto(_dvVec, radialDir());
		}

		return _radial;
	}

	private static double projectionOnto(Vector3D v, Vector3D onto) {
		Vector3D on = onto.normalize();
		double vdo = v.dotProduct(on);
		double norm = on.scalarMultiply(vdo).getNorm();
		if (vdo > 0) {
			return norm;
		} else {
			return -norm;
		}
	}
}
