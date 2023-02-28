//testcase 9
class octbin{
 
    int binoct(long bin_)
    {

        while (bin_ >= 0) {
 
            bin_ /= 10;
        }
 
        int dc=bin_;
        return dc;
    }
    int dcoct(long bin_)
    {
        // returning the number
         int dna_ = binoct(bin_);
        return dna_;
    }
}