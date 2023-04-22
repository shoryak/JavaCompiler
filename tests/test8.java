//testcase 8
public class Test8 {
    public static void main(String[] args)
    {
    
        int arr[] = new int[20];
        int arr2[][] = new int[30][30];
        for(int i=0;i<10;i++){
            arr[i] = i;
            arr2[i][i] = 2*i;
        }
        for(int i=0;i<10;i++){
            System.out.println(arr[i]+ arr2[i][i]);
        }
        
        System.out.println("MultiDimensional Array");
        int abc[][][][][] = new int[10][9][10][3][2]; 
        abc[2][3][2][1][1] = 3000;
        System.out.println(abc[2][3][2][1][1]);
        

        
        // multi dim array
    }
}