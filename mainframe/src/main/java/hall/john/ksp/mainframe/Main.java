package hall.john.ksp.mainframe;

import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class Main {
	public static String KSP_SCRIPT_DIR = "C:\\Games\\Steam\\steamapps\\common\\Kerbal Space Program 1.1.3\\Ships\\Script";
	public static String KSP_REQUEST_FILE = KSP_SCRIPT_DIR + "\\libmainframe_request.txt";
	public static Path KSP_REQUEST_PATH = Paths.get(KSP_REQUEST_FILE);
	public static String KSP_REQUEST_DONE_FILE = KSP_SCRIPT_DIR + "\\libmainframe_request_done.txt";
	public static Path KSP_REQUEST_DONE_PATH = Paths.get(KSP_REQUEST_DONE_FILE);
	public static String KSP_RESULT_FILE = KSP_SCRIPT_DIR + "\\libmainframe_result.json";
	public static Path KSP_RESULT_PATH = Paths.get(KSP_RESULT_FILE);
	public static String KSP_RESULT_DONE_FILE = KSP_SCRIPT_DIR + "\\libmainframe_result_done.txt";
	public static Path KSP_RESULT_DONE_PATH = Paths.get(KSP_RESULT_DONE_FILE);

	public static void main(String[] args) throws Exception {
		while (true) {
			System.out.println("\nWaiting for requests");

			while (!Files.exists(KSP_REQUEST_DONE_PATH)) {
				Thread.sleep(250);
			}

			List<String> lines = Files.readAllLines(KSP_REQUEST_PATH);
			String requestType = lines.get(0);
			List<String> requestArgs = lines.subList(1, lines.size());

			System.out.println("Received request: " + requestType);

			Map<String, Object> result = null;
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

			try (PrintWriter pw = new PrintWriter(KSP_RESULT_FILE)) {
				writeMap(result, pw, "");
			}

			try (FileOutputStream fos = new FileOutputStream(KSP_RESULT_DONE_FILE)) {
			}

			Thread.sleep(1000);// wait for kOS to delete the request done file
		}
	}

	private static void writeMapEntry(String key, Object value, boolean isLast, PrintWriter pw, String indentation) {
		pw.println(indentation + "\"" + key + "\",");
		String str = indentation;

		if (value instanceof String) {
			str += "\"" + value + "\"";
		} else if (value instanceof Number) {
			str += value;
		} else {
			throw new RuntimeException("unknown value type (value = " + value + ")");
		}

		if (!isLast) {
			str += ",";
		}

		pw.println(str);
	}

	private static void writeMap(Map<String, Object> map, PrintWriter pw, String indentation) {
		pw.println(indentation + "{");
		pw.println(indentation + "    \"entries\": [");

		Iterator it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<String, Object> entry = (Map.Entry<String, Object>) it.next();
			writeMapEntry(entry.getKey(), entry.getValue(), !it.hasNext(), pw, indentation + "        ");
		}

		pw.println(indentation + "    ],");
		pw.println(indentation + "    \"$type\": \"kOS.Safe.Encapsulation.Lexicon\"");
		pw.println(indentation + "}");
	}
}
