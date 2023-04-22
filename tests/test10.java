
class Types{  
    public static void main(String args[])  
    {      
        long var_long  = 100000;
        System.out.println(var_long);
        int var_int = (int)var_long;
        System.out.println(var_int);
        var_long = 1000000000000;
        System.out.println(var_long);
        var_int = (int)var_long;
        System.out.println(var_int);
        var_int = 900;
        byte var_byte = (byte)var_int;
        System.out.println(var_byte);
        var_int = 90;
        var_byte = (byte)var_int;
        System.out.println(var_byte);
    }
}  