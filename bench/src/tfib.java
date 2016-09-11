// file: "tfib.java"

class FibThread extends Thread
 {
  FibThread (int arg) { n = arg; }

  public void run ()
    { try { result = fib (n); } catch (InterruptedException e) { } }

  private int n;

  public int result;

  private int fib (int n)
     throws InterruptedException
    {
      if (n < 2)
        return 1;
      else
        {
          FibThread x = new FibThread (n-2);
          x.start ();
          int y = fib (n-1);
          x.join ();
          return x.result + y;
        }
    }
 }

class tfib
 {
  public static void main (String[] args)
     throws InterruptedException
   {
    int n = 14; // Integer.parseInt (args[0]);
    int repeat = 100; //Integer.parseInt (args[1]);
    FibThread x;

    do
      {
        x = new FibThread (n);
        x.start ();
        x.join ();
        repeat--;
      } while (repeat > 0);

    System.out.println (x.result);
  }
 }
