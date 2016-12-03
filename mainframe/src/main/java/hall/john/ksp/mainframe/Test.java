package hall.john.ksp.mainframe;

import java.io.FileWriter;

import hall.john.ksp.mainframe.orbit.OrbitAtTime;

public class Test {

	public static void main(String[] args) throws Exception {
		Body b = new Body("Earth", 3.986004418E14);

		OrbitAtTime oat1 = new OrbitAtTime(b, 6571000, 0.0001, 0, 0, 0, 0);
		OrbitAtTime oat2 = new OrbitAtTime(b, 6671000, 0.4, 0, 0, 0, 0);

		try (FileWriter fw = new FileWriter(
				"C:\\Games\\Steam\\steamapps\\common\\Kerbal Space Program 1.1.3\\Ships\\Script\\data.txt")) {
			for (double t = 0; t < 2 * oat1.getPeriod(); t += 5) {
				OrbitAtTime newOat1 = oat1.afterTime(t);
				OrbitAtTime newOat2 = oat2.afterTime(t);
				double dist = newOat1.getRadiusVector().distance(newOat2.getRadiusVector());
				fw.append(t + " " + dist + "\n");
			}
		}
	}

}
