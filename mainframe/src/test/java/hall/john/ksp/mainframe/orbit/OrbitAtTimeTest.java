package hall.john.ksp.mainframe.orbit;

import static org.junit.Assert.assertEquals;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;
import org.junit.Test;

import hall.john.ksp.mainframe.Body;
import hall.john.ksp.mainframe.TestUtils;

public class OrbitAtTimeTest {
	@Test
	public void elemCtorAndRetrieval() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;
		double ta = 3 * Math.PI / 2;

		OrbitAtTime oat = new OrbitAtTime(b, a, e, i, lan, aop, ta);
		assertEquals(b, oat.getBody());
		TestUtils.assertRelativelyEquals(a, oat.getSemiMajorAxis(), 1e-9);
		TestUtils.assertRelativelyEquals(a, oat.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, oat.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, oat.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, oat.getLongitudeOfAscendingNode(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, oat.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, oat.getArgumentOfPeriapsis(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, oat.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(ta, oat.getTrueAnomaly(), 1e-9);
	}

	@Test
	public void calcEccentricAnomaly1() {
		Body b = new Body("A", 1);
		double ta = Math.PI / 2;
		OrbitAtTime oat = new OrbitAtTime(b, 1, 0, 0, 0, 0, ta);
		TestUtils.assertRelativelyEquals(ta, oat.getEccentricAnomaly(), 1e-6);
	}

	@Test
	public void calcEccentricAnomaly2() {
		Body b = new Body("A", 1);
		double ta = 3 * Math.PI / 2;
		OrbitAtTime oat = new OrbitAtTime(b, 1, 0, 0, 0, 0, ta);
		TestUtils.assertRelativelyEquals(ta, oat.getEccentricAnomaly(), 1e-6);
	}

	@Test
	public void calcMeanAnomaly() {
		Body b = new Body("A", 1);
		double ta = 3 * Math.PI / 2;
		OrbitAtTime oat = new OrbitAtTime(b, 1, 0, 0, 0, 0, ta);
		TestUtils.assertRelativelyEquals(ta, oat.getMeanAnomaly(), 1e-6);
	}

	@Test
	public void calcECIVectors1() {
		OrbitAtTime oat = new OrbitAtTime(new Body("A", 1), 1, 0, 0, 0, 0, 0);
		TestUtils.assertVectorRelativelyEquals(1, 0, 0, oat.getRadiusVector(), 1e-6);
		TestUtils.assertVectorRelativelyEquals(0, 1, 0, oat.getVelocityVector(), 1e-6);
	}

	@Test
	public void calcECIVectors2() {
		OrbitAtTime oat = new OrbitAtTime(new Body("A", 1), 0.66667, 0.5, Math.PI / 4, 0, Math.PI, Math.PI);
		TestUtils.assertVectorRelativelyEquals(1, 0, 0, oat.getRadiusVector(), 1e-5);
		TestUtils.assertVectorRelativelyEquals(0, 0.5, 0.5, oat.getVelocityVector(), 1e-5);
	}

	@Test
	public void calcECIVectors3() {
		OrbitAtTime oat = new OrbitAtTime(new Body("A", 1), 0.8, 0.61237244, Math.PI / 4, 0,
				Math.toRadians(215.26438968), Math.toRadians(144.73561032));
		TestUtils.assertVectorRelativelyEquals(1, 0, 0, oat.getRadiusVector(), 1e-5);
		TestUtils.assertVectorRelativelyEquals(0.5, 0.5, 0.5, oat.getVelocityVector(), 1e-5);
	}

	@Test
	public void calcECIVectors4() {
		OrbitAtTime oat = new OrbitAtTime(new Body("A", 1), 0.66667, 0.79056942, Math.PI / 2, 0,
				Math.toRadians(71.56505118), Math.toRadians(198.43494882));
		TestUtils.assertVectorRelativelyEquals(0, 0, -1, oat.getRadiusVector(), 1e-5);
		TestUtils.assertVectorRelativelyEquals(0.5, 0, 0.5, oat.getVelocityVector(), 1e-5);
	}

	@Test
	public void calcECIVectors5() {
		OrbitAtTime oat = new OrbitAtTime(new Body("A", 1), 0.66667, 0.5, Math.PI / 4, 3 * Math.PI / 2, Math.PI,
				Math.PI);
		TestUtils.assertVectorRelativelyEquals(0, -1, 0, oat.getRadiusVector(), 1e-5);
		TestUtils.assertVectorRelativelyEquals(0.5, 0, 0.5, oat.getVelocityVector(), 1e-5);
	}

	@Test
	public void copyCtorAndRetrieval() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;
		double ta = 3 * Math.PI / 2;

		OrbitAtTime oat = new OrbitAtTime(b, a, e, i, lan, aop, ta);
		OrbitAtTime oat2 = new OrbitAtTime(oat);
		assertEquals(b, oat.getBody());
		TestUtils.assertRelativelyEquals(a, oat2.getSemiMajorAxis(), 1e-9);
		TestUtils.assertRelativelyEquals(a, oat2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, oat2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, oat2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, oat2.getLongitudeOfAscendingNode(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, oat2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, oat2.getArgumentOfPeriapsis(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, oat2.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(ta, oat2.getTrueAnomaly(), 1e-9);
	}

	@Test
	public void eciCtorAndRetrieval() {
		Body b = new Body("A", 1);
		Vector3D rVec = new Vector3D(1, 2, 3);
		Vector3D vVec = new Vector3D(4, 5, 6);

		OrbitAtTime oat = new OrbitAtTime(b, rVec, vVec);
		assertEquals(b, oat.getBody());
		TestUtils.assertVectorRelativelyEquals(1, 2, 3, oat.getRadiusVector(), 1e-5);
		TestUtils.assertVectorRelativelyEquals(4, 5, 6, oat.getVelocityVector(), 1e-5);
	}

	@Test
	public void fromECI1() {
		Body b = new Body("A", 1);
		Vector3D rVec = new Vector3D(1, 0, 0);
		Vector3D vVec = new Vector3D(0, 1, 0);

		OrbitAtTime oat = new OrbitAtTime(b, rVec, vVec);
		TestUtils.assertRelativelyEquals(1, oat.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(0, oat.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(0, oat.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(0, oat.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(0, oat.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(0, oat.getTrueAnomaly(), 1e-9);
	}

	@Test
	public void fromECI2() {
		Body b = new Body("A", 1);
		Vector3D rVec = new Vector3D(1, 0, 0);
		Vector3D vVec = new Vector3D(0, 0.5, 0.5);

		OrbitAtTime oat = new OrbitAtTime(b, rVec, vVec);
		TestUtils.assertRelativelyEquals(0.66667, oat.getSMA(), 1e-5);
		TestUtils.assertRelativelyEquals(0.5, oat.getEccentricity(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI / 4, oat.getInclination(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getLAN(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI, oat.getAOP(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI, oat.getTrueAnomaly(), 1e-5);
	}

	@Test
	public void fromECI3() {
		Body b = new Body("A", 1);
		Vector3D rVec = new Vector3D(1, 0, 0);
		Vector3D vVec = new Vector3D(0.5, 0.5, 0.5);

		OrbitAtTime oat = new OrbitAtTime(b, rVec, vVec);
		TestUtils.assertRelativelyEquals(0.8, oat.getSMA(), 1e-5);
		TestUtils.assertRelativelyEquals(0.61237244, oat.getEccentricity(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI / 4, oat.getInclination(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getLAN(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.toRadians(215.26438968), oat.getAOP(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.toRadians(144.73561032), oat.getTrueAnomaly(), 1e-5);
	}

	@Test
	public void fromECI4() {
		Body b = new Body("A", 1);
		Vector3D rVec = new Vector3D(0, 0, -1);
		Vector3D vVec = new Vector3D(0.5, 0, 0.5);

		OrbitAtTime oat = new OrbitAtTime(b, rVec, vVec);
		TestUtils.assertRelativelyEquals(0.66667, oat.getSMA(), 1e-5);
		TestUtils.assertRelativelyEquals(0.79056942, oat.getEccentricity(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI / 2, oat.getInclination(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getLAN(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.toRadians(71.56505118), oat.getAOP(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.toRadians(198.43494882), oat.getTrueAnomaly(), 1e-5);
	}

	@Test
	public void fromECI5() {
		Body b = new Body("A", 1);
		Vector3D rVec = new Vector3D(0, -1, 0);
		Vector3D vVec = new Vector3D(0.5, 0, 0.5);

		OrbitAtTime oat = new OrbitAtTime(b, rVec, vVec);
		TestUtils.assertRelativelyEquals(0.66667, oat.getSMA(), 1e-5);
		TestUtils.assertRelativelyEquals(0.5, oat.getEccentricity(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI / 4, oat.getInclination(), 1e-5);
		TestUtils.assertRelativelyEquals(3 * Math.PI / 2, oat.getLAN(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI, oat.getAOP(), 1e-5);
		TestUtils.assertRelativelyEquals(Math.PI, oat.getTrueAnomaly(), 1e-5);
	}

	@Test
	public void fromECI6() {
		Body b = new Body("A", 1);
		Vector3D rVec = new Vector3D(0.99998629, 0.00523596, 0);
		Vector3D vVec = new Vector3D(-0.00523596, 0.99998629, 0);

		OrbitAtTime oat = new OrbitAtTime(b, rVec, vVec);
		TestUtils.assertRelativelyEquals(1, oat.getSMA(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getEccentricity(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getInclination(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getLAN(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getAOP(), 1e-5);
		TestUtils.assertRelativelyEquals(0, oat.getTrueAnomaly(), 1e-2);
	}

	@Test
	public void orbitTrueAnomalyCtorAndRetrieval() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;
		double ta = 3 * Math.PI / 2;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		OrbitAtTime oat = new OrbitAtTime(o, ta);
		assertEquals(b, oat.getBody());
		TestUtils.assertRelativelyEquals(a, oat.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, oat.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, oat.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, oat.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, oat.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(ta, oat.getTrueAnomaly(), 1e-9);
	}

	@Test
	public void afterTime() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;
		double ta = 3 * Math.PI / 2;

		OrbitAtTime oat = new OrbitAtTime(b, a, e, i, lan, aop, ta);
		OrbitAtTime oat2 = oat.afterTime(oat.getPeriod() / 2);
		assertEquals(b, oat2.getBody());
		TestUtils.assertRelativelyEquals(a, oat2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, oat2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, oat2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, oat2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, oat2.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(2.90066220105092, oat2.getTrueAnomaly(), 1e-9);
	}
}
