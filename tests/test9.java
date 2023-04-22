//testCASE5
public class Test9 {
	private
		int a;
		int x;
	public
	  Test9(int a){
		this.a = a;
		this.x = 2*a;
	  }  

	  public static int func(Test9 obj1 , Test9 obj2){
		return obj1.a + obj2.x;
	  }
	
	  public static void main(String[] args) {
		Test9 obj1 = new Test9(100);
		Test9 obj2 = new Test9(200);
		int res1 = func(obj1,obj2);   
		System.out.println(res1);
		int res2 = func(obj2,obj1);   
		System.out.println(res2);
	  }
  
}