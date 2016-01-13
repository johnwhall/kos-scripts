package hall.john.ksp.mainframe.orbit;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

import hall.john.ksp.mainframe.Body;
import hall.john.ksp.mainframe.TestUtils;

public class OrbitTest {
	@Test
	public void ctorAndRetrieval() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		assertEquals(b, o.getBody());
		TestUtils.assertRelativelyEquals(a, o.getSemiMajorAxis(), 1e-9);
		TestUtils.assertRelativelyEquals(a, o.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, o.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, o.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o.getLongitudeOfAscendingNode(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o.getArgumentOfPeriapsis(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o.getAOP(), 1e-9);
	}

	@Test
	public void apoapsis() {
		Body b = new Body("A", 1);
		double a = 3;
		double e = 0.5;

		Orbit o = new Orbit(b, a, e, 0, 0, 0);
		TestUtils.assertRelativelyEquals(4.5, o.getApoapsis(), 1e-9);
	}

	@Test
	public void periapsis() {
		Body b = new Body("A", 1);
		double a = 3;
		double e = 0.5;

		Orbit o = new Orbit(b, a, e, 0, 0, 0);
		TestUtils.assertRelativelyEquals(1.5, o.getPeriapsis(), 1e-9);
	}

	@Test
	public void withApoapsis() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		Orbit o2 = o.withApoapsis(2);

		assertEquals(b, o2.getBody());
		TestUtils.assertRelativelyEquals(1.25, o2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(0.6, o2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, o2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o2.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(o.getPeriapsis(), o2.getPeriapsis(), 1e-9);
		TestUtils.assertRelativelyEquals(2, o2.getApoapsis(), 1e-9);
	}

	@Test
	public void withPeriapsis() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		Orbit o2 = o.withPeriapsis(0.75);

		assertEquals(b, o2.getBody());
		TestUtils.assertRelativelyEquals(1.125, o2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(0.3333333333, o2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, o2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o2.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(0.75, o2.getPeriapsis(), 1e-9);
		TestUtils.assertRelativelyEquals(o.getApoapsis(), o2.getApoapsis(), 1e-9);
	}

	@Test
	public void withSMA() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		Orbit o2 = o.withSMA(2);
		assertEquals(b, o2.getBody());
		TestUtils.assertRelativelyEquals(2, o2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, o2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, o2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o2.getAOP(), 1e-9);
	}

	@Test
	public void withEccentricity() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		Orbit o2 = o.withEccentricity(0.25);
		assertEquals(b, o2.getBody());
		TestUtils.assertRelativelyEquals(a, o2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(0.25, o2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, o2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o2.getAOP(), 1e-9);
	}

	@Test
	public void withInclination() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		Orbit o2 = o.withInclination(Math.PI / 2);
		assertEquals(b, o2.getBody());
		TestUtils.assertRelativelyEquals(a, o2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, o2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(Math.PI / 2, o2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o2.getAOP(), 1e-9);
	}

	@Test
	public void withLAN() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		Orbit o2 = o.withLAN(Math.PI / 4);
		assertEquals(b, o2.getBody());
		TestUtils.assertRelativelyEquals(a, o2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, o2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, o2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(Math.PI / 4, o2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, o2.getAOP(), 1e-9);
	}

	@Test
	public void withAOP() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		Orbit o2 = o.withAOP(3 * Math.PI / 2);
		assertEquals(b, o2.getBody());
		TestUtils.assertRelativelyEquals(a, o2.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, o2.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, o2.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, o2.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(3 * Math.PI / 2, o2.getAOP(), 1e-9);
	}

	@Test
	public void withTrueAnomaly() {
		Body b = new Body("A", 1);
		double a = 1;
		double e = 0.5;
		double i = Math.PI / 4;
		double lan = Math.PI / 2;
		double aop = Math.PI;
		double ta = Math.PI / 2;

		Orbit o = new Orbit(b, a, e, i, lan, aop);
		OrbitAtTime oat = o.withTrueAnomaly(ta);

		assertEquals(b, oat.getBody());
		TestUtils.assertRelativelyEquals(a, oat.getSMA(), 1e-9);
		TestUtils.assertRelativelyEquals(e, oat.getEccentricity(), 1e-9);
		TestUtils.assertRelativelyEquals(i, oat.getInclination(), 1e-9);
		TestUtils.assertRelativelyEquals(lan, oat.getLAN(), 1e-9);
		TestUtils.assertRelativelyEquals(aop, oat.getAOP(), 1e-9);
		TestUtils.assertRelativelyEquals(ta, oat.getTrueAnomaly(), 1e-9);
	}

	@Test
	public void period() {
		Body b = new Body("Earth", 398600441800000.0);
		double a = 6774500;
		double e = 0.0006531;
		double i = Math.toRadians(51.6443);
		double lan = Math.toRadians(117.8784);
		double aop = Math.toRadians(15.1371);

		Orbit o = new Orbit(b, a, e, i, lan, aop);

		TestUtils.assertRelativelyEquals(5549.154941027046, o.getPeriod(), 1e-9);
	}

	@Test
	public void meanAngularMotion() {
		Body b = new Body("Earth", 398600441800000.0);
		double a = 6774500;
		double e = 0.0006531;
		double i = Math.toRadians(51.6443);
		double lan = Math.toRadians(117.8784);
		double aop = Math.toRadians(15.1371);

		Orbit o = new Orbit(b, a, e, i, lan, aop);

		TestUtils.assertRelativelyEquals(0.00113227786, o.getMeanAngularMotion(), 1e-6);
	}

}
