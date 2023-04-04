class checkthis
{
	long a;
	int b;
	
	checkthis(int a)
	{
		this.a = a;
		this.b = 5;
	
	}
    // above is paramaterised const and this keyword
	void diskfn()
	{
		
      int x = 10;
      int y = -100;
      int z = 3;
      float a = 2;
  
    //   double largest = (x > y) ? ((z > z) ? y : y) : ((x <= a) ? a : x);
      
      System.out.println("ternary");
	}
	
	int func(int a, int b)
	{
	    // checkthis c = new checkthis(200);
		checkthis c;
	    diskfn();
	    c.diskfn();
		return 10;
	}
}

class Main
{
    public static void main()
    {
		checkthis object = new checkthis(100);
		// checkthis object;
		object.func();

    }
}