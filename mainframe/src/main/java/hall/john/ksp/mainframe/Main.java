package hall.john.ksp.mainframe;

import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

public class Main {
	public static String KSP_SCRIPT_DIR = "/home/jhall/.steam/steam/SteamApps/common/KSP_1.0.5/Ships/Script";
	public static String KSP_REQUEST_FILE = KSP_SCRIPT_DIR + "/libmainframe_request.txt";
	public static Path KSP_REQUEST_PATH = Paths.get(KSP_REQUEST_FILE);
	public static String KSP_REQUEST_DONE_FILE = KSP_SCRIPT_DIR + "/libmainframe_request_done.txt";
	public static Path KSP_REQUEST_DONE_PATH = Paths.get(KSP_REQUEST_DONE_FILE);
	public static String KSP_RESULT_DONE_FILE = KSP_SCRIPT_DIR + "/libmainframe_result_done.txt";
	public static Path KSP_RESULT_DONE_PATH = Paths.get(KSP_RESULT_DONE_FILE);

	public static void main(String[] args) throws Exception {
		while (true) {
			System.out.println("\nWaiting for requests");

			while (!Files.exists(KSP_REQUEST_DONE_PATH)) {
				Thread.sleep(250);
			}

			Files.delete(KSP_REQUEST_DONE_PATH);

			List<String> lines = Files.readAllLines(KSP_REQUEST_PATH);
			int requestNum = Integer.parseInt(lines.get(0));
			String requestType = lines.get(1);
			List<String> requestArgs = lines.subList(2, lines.size());

			System.out.println("Received request: " + requestType);

			String result = "";
			switch (requestType) {
				case "square":
					result = Square.Square(requestArgs);
					break;
				case "lambertoptimize":
					result = LambertOptimizer.mainframe(requestArgs);
					break;
				default:
					throw new IllegalArgumentException("unknown request type: " + requestType);
			}

			String resultFile = KSP_SCRIPT_DIR + "/libmainframe_result_" + requestNum + ".ks";
			try (PrintWriter writer = new PrintWriter(resultFile)) {
				writer.write("set RETVAL to " + result + ".");
			}

			try (FileOutputStream fos = new FileOutputStream(KSP_RESULT_DONE_FILE)) { }

		}
	}
}
