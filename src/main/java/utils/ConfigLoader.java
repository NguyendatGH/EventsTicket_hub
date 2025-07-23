package utils;

import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {
    private static Properties props = new Properties();

    static {
        try {

            InputStream input = ConfigLoader.class.getClassLoader().getResourceAsStream("config.properties");
            if (input == null) {
                System.err.println(" Không tìm thấy file config.properties!");
            } else {
                props.load(input);
                System.out.println(" Đã load config.properties!");
            }
        } catch (Exception e) {
            System.err.println(" Lỗi khi load config.properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        String value = props.getProperty(key);
        System.out.println("🔎 " + key + " = " + value);
        return value;
    }
}
