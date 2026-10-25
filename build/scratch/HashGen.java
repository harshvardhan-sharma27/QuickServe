import org.mindrot.jbcrypt.BCrypt;

public class HashGen {
    public static void main(String[] args) {
        String p1 = BCrypt.hashpw("Password@123", BCrypt.gensalt(10));
        String p2 = BCrypt.hashpw("Admin@123", BCrypt.gensalt(10));
        System.out.println("HASH_PASSWORD=" + p1);
        System.out.println("HASH_ADMIN=" + p2);
    }
}
