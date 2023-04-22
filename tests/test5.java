//testCASE5
public class Main {
	private
		int a;
		int x;
	public
	  Main(int a){
		this.x = a;
  
	  }  
	  
	  public void mult(int q){
		  this.a  = this.a*q;
	  }
	
	  public void Public__Method(int x, int y) {
		this.a = x+y;
		mult(37);
	  }
	
	  public static void main(String[] args) {
		int init = 10;
		Main obj = new Main(init);
		obj.Public__Method(90,10);  
		System.out.println(obj.a);
	  }
  
}