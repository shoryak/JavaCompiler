class checkthis
{
	int a;
	int b;
	
	checkthis(int a)
	{
		this.a = a;
	
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

	public static void main(String[] args)
	{
		checkthis object = new checkthis(100);
		object.diskfn();
	}
}