package Barreras is

   protected type Barrier is
      entry Wait; -- se declara entry cdo va a haber condición barrera; si no, se declara un proc normal
      procedure Go;
   private -- como el cuerpo de un OP no puede declarar vbles, todas las necesarias en la esp. en private
      Opened: Boolean:=False; -- valor inicial: FALSE
   end Barrier;

end Barreras;
