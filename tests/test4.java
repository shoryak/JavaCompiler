//testCASE4
public class Main {
  
    static void myStatMethod() {
      System.out.println("Static is better or not");
    }
  
    public void Public__Method() {
      System.out.println("Public is better or not");
    }
  
    public static void main(String[] args) {
      myStatMethod(); // Static is better
  
      
      myObject.Public__Method();  
      Main myObject = new Main(); 
    }
  }