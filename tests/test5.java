//testCASE5
public class Main {
		int a;
		String str;
	  
	  Main(String a){
		this.str = a;
  
	  }  
	  
	
	  public void Public__Method(int x, int y) {
		this.a = x+y;
	  }
	
	  public static void main(String[] args) {
		Main obj = new Main();
		obj.Public__Method(10,10);
  
		
	  }
  
	  public static void somefunc(String arg1, int arg2) {}
	}