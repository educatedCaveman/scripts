bool isPrime(int x)
{
    //set up variables
    int i = 2;
    bool prime = false;
    
    //eliminate negative numbers, and 0-2
    if (x < 3)
    {
        return false;
    }
    
    /*if i divides x evenly, its not prime.
    check for all i < x*/
    while ( i < x )
    {
        if ( x % i == 0 )
            return prime;
        i++;
    }
    
    //otherwise, x is prime!
    prime = true;
    return prime;

}
