generic
   N: Positive;
   type Item is private;

package TamponOP is
   type Tampon is array(1..N) of Item; -- aqu� para que est� visible al declarar Cola de tipo tamp�n

   protected type Tampon_Circular is

      entry Anyadir(I: in Item); -- operaci�n protegida
      entry Sacar (I: out Item); -- operaci�n protegida

   private  -- variables a las que debo acceder en exclusi�n mutua
      Cola:  Tampon;
      Primero, Ultimo : Integer := 1;
      Contador: Integer:=0;
   end Tampon_Circular;
end TamponOP;
