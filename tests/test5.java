// Test case 5

class nest_If {
	public static void main(String args[])
	{
		int i ;
        
        int j=10;
        i=j;

        i--;
        j++;


		if (i == 1 || i > 5) {
	
			if (i == 5)
				System.out.println("i is 5");

			if (i > 2)
				System.out.println("i is > 2");
            else if (i == 1)
                System.out.println("i is value 1");
		} else{
				System.out.println("i is other");
		}
	}
}