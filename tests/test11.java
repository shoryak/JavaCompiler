class Test11
{
    static void towerOfHanoi(int n)
    {
        System.out.print("Disks are numbered 1 (smallest, at top) to ");
        System.out.println(n);
        System.out.println(" (largest, at bottom)...");
        towerOfHanoiHelper(n, 1, 3, 2);
    }
	static void towerOfHanoiHelper(int n, int fromPeg, int toPeg, int auxPeg)
    {
		if (n == 1)
        {
            System.out.println();
			System.out.print("Move the disk ");
            System.out.print(n);
            System.out.print(" from the rod ");
            System.out.print(fromPeg);
            System.out.print( " to the rod ");
            System.out.println(toPeg);
			return;
		}
		towerOfHanoiHelper(n-1, fromPeg, auxPeg, toPeg);
        System.out.println();
		System.out.print("Move the disk ");
        System.out.print(n);
        System.out.print(" from the rod ");
        System.out.print(fromPeg);
        System.out.print( " to the rod ");
        System.out.println(toPeg);
		towerOfHanoiHelper(n-1, auxPeg, toPeg, fromPeg);
        return;
	}
	public static void main(String args[])
    {
		towerOfHanoi(5);
        return;
	}
}
