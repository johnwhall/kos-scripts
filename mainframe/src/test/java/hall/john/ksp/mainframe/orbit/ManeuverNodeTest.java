package hall.john.ksp.mainframe.orbit;

import static org.junit.Assert.assertEquals;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;
import org.junit.Before;
import org.junit.Test;

import hall.john.ksp.mainframe.Body;
import hall.john.ksp.mainframe.TestUtils;

public class ManeuverNodeTest {
	private OrbitAtTime _oat;

	@Before
	public void setUp() {
		_oat = new OrbitAtTime(new Body("A", 1), new Vector3D(1, 0, 0), new Vector3D(1, 2, 3));
	}

	@Test
	public void dvVecCtorAndRetrieval() {
		ManeuverNode m = new ManeuverNode(_oat, new Vector3D(3, 2, 1));
		assertEquals(_oat, m.getOAT());
		TestUtils.assertVectorRelativelyEquals(3, 2, 1, m.getDVVec(), 1e-9);
	}

	@Test
	public void pnrCtorAndRetrieval() {
		ManeuverNode m = new ManeuverNode(_oat, 3, 2, 1);
		assertEquals(_oat, m.getOAT());
		TestUtils.assertRelativelyEquals(3, m.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(2, m.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(1, m.getRadial(), 1e-9);
	}

	@Test
	public void magnitudeCalculation() {
		ManeuverNode m = new ManeuverNode(_oat, new Vector3D(3, 2, 1));
		TestUtils.assertRelativelyEquals(3.74165738677, m.getDV(), 1e-9);
	}

	@Test
	public void progradeOnlyCalculation() {
		Body b = new Body("A", 1);
		Vector3D r = new Vector3D(1, 0, 0);
		Vector3D v = new Vector3D(0, 1, 0);
		OrbitAtTime oat = new OrbitAtTime(b, r, v);
		ManeuverNode m = new ManeuverNode(oat, new Vector3D(0, 2, 0));
		TestUtils.assertRelativelyEquals(2, m.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m.getRadial(), 1e-9);

		ManeuverNode m2 = new ManeuverNode(oat, new Vector3D(0, -2, 0));
		TestUtils.assertRelativelyEquals(-2, m2.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m2.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m2.getRadial(), 1e-9);
	}

	@Test
	public void normalOnlyCalculation() {
		Body b = new Body("A", 1);
		Vector3D r = new Vector3D(1, 0, 0);
		Vector3D v = new Vector3D(0, 1, 0);
		OrbitAtTime oat = new OrbitAtTime(b, r, v);
		ManeuverNode m = new ManeuverNode(oat, new Vector3D(0, 0, 2));
		TestUtils.assertRelativelyEquals(0, m.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(2, m.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m.getRadial(), 1e-9);

		ManeuverNode m2 = new ManeuverNode(oat, new Vector3D(0, 0, -2));
		TestUtils.assertRelativelyEquals(0, m2.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(-2, m2.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m2.getRadial(), 1e-9);
	}

	@Test
	public void radialOnlyCalculation() {
		Body b = new Body("A", 1);
		Vector3D r = new Vector3D(1, 0, 0);
		Vector3D v = new Vector3D(0, 1, 0);
		OrbitAtTime oat = new OrbitAtTime(b, r, v);
		ManeuverNode m = new ManeuverNode(oat, new Vector3D(2, 0, 0));
		TestUtils.assertRelativelyEquals(0, m.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(2, m.getRadial(), 1e-9);

		ManeuverNode m2 = new ManeuverNode(oat, new Vector3D(-2, 0, 0));
		TestUtils.assertRelativelyEquals(0, m2.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(0, m2.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(-2, m2.getRadial(), 1e-9);
	}

	@Test
	public void pnrCalculation() {
		Body b = new Body("A", 1);
		Vector3D r = new Vector3D(1, 2, 0);
		Vector3D v = new Vector3D(1, 1, 0);
		OrbitAtTime oat = new OrbitAtTime(b, r, v);
		ManeuverNode m = new ManeuverNode(oat, new Vector3D(1, 3, 1));
		TestUtils.assertRelativelyEquals(2.8284271247461894, m.getPrograde(), 1e-9);
		TestUtils.assertRelativelyEquals(-1, m.getNormal(), 1e-9);
		TestUtils.assertRelativelyEquals(1.4142135623730954, m.getRadial(), 1e-9);
	}

	@Test
	public void dvVecCalculation() {
		Body b = new Body("A", 1);
		Vector3D r = new Vector3D(1, 2, 0);
		Vector3D v = new Vector3D(1, 1, 0);
		OrbitAtTime oat = new OrbitAtTime(b, r, v);
		ManeuverNode m = new ManeuverNode(oat, 2.8284271247461894, -1, 1.4142135623730954);
		TestUtils.assertVectorRelativelyEquals(1, 3, 1, m.getDVVec(), 1e-9);
	}

}
