public class Test12  
{    
    //print pattern
    public static void main(String args[]) {
        int j;
        int k = 6;  
        long cnt=0;     
        for(int i = 0; i<k; i++)   
        {  

            for (j = k-i; ; --j)   
            {  
                if(j<2){
                    break;
                }
                System.out.print(" ");   
            }   
            while(j<=i)   
            {   
                ++j;
                System.out.print("* ");   
            } 
            cnt-- ;
            System.out.println();      
        }   
    }   
}  