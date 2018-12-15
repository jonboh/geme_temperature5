package body TamponOP is

   protected body Tampon_Circular is
      entry Anyadir(I: in Item) when Contador < N is
      begin
         Cola(Primero) := I;
         Primero := (Primero mod N) + 1;
         Contador :=  Contador + 1;
      end Anyadir;

      entry Sacar (I: out Item) when Contador > 0 is
      begin
         I := Cola(Ultimo);
         Ultimo := (Ultimo mod N) +1;
         Contador :=  Contador - 1;
      end Sacar;
      end Tampon_Circular;

   begin
      null;
   end TamponOP;
