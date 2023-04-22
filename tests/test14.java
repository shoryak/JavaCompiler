public class Test14 {    
    public static void main(String[] args) {    
        int k=2;
        int a=2;
        k-=2;
        System.out.println(k);
        k+=5;
        System.out.println(k);
        a =  a + 100;
        k=k>>(3&2);
        k+=(a^a);
        System.out.println(k);
        k= -a;
        System.out.println(k);
    }    
}    