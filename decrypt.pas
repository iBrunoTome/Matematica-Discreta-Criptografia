{

Nome: Bruno Tomé: Matrícula: 0011254 email: ibrunotome@gmail.com
Nome: Ronan Nunes: Matrícula: 0011919 email: ronannc1@yahoo.com.br

Nome do aplicativo: Decrypt

Instruções para compilação: com todos os arquivos necessários no
desktop use a seguinte linha de comando:

================================================
cd Desktop/

fpc decrypt.pas -odecrypt.bin

./decrypt.bin <CHAVE> <ENTRADA.TXT> <SAIDA.TXT>
================================================

No qual o que está em caixa alta deve ser substituído pelos
respectivos nomes de chave e arquivo.

Módulo: A função serve para encontrarmos o resto de uma divisão
de inteiros.

}

program decrypt;
uses crt;
// Lendo o arquivo de entrada, que é o parâmetro 2 passado no terminal
function LeArquivo():string;
var f1: text;
    s,textoArquivo:string;
begin
     s:='';
     assign(f1,ParamStr(2));
     reset(f1);
     while (not(eof(f1))) do
     begin
          readln(f1,s);
          textoArquivo:=s;
     end;
     close(f1);
     LeArquivo:=textoArquivo;
end;

// Recebendo a chave digitada no terminal, que é o parâmetro 1
function RecebeChave():string;
var chavefun: string;
begin
     chavefun:=ParamStr(1);
     RecebeChave:=chavefun;
end;

// Função de módulo implementada sem o uso de operadores mod e div
function Modulo(dividendo,divisor:integer):integer;
var resto,contador: integer;
begin
     resto:=dividendo;
     contador:=0;
     repeat
           resto:=resto-divisor;
           inc(contador);
     until(resto<=0);
     if (resto=0) then
     begin
          Modulo:=(dividendo-(contador*divisor));
     end
     else if (resto<0) then
     begin
          Modulo:=(dividendo-(contador*divisor)+divisor);
     end;
end;

// Função que converte o texto em números de acordo com a
// tabela que foi fornecida
function ConverteAscii2Numero(texto: string):string;
var i,tam: integer;
    numero,aux: string;

begin
     aux:='';
     tam:= 1;
     for i:=1 to length(texto) do
     begin
          case lowercase(texto[i]) of
               'a' : numero:=('00');
               'b' : numero:=('01');
               'c' : numero:=('02');
               'd' : numero:=('03');
               'e' : numero:=('04');
               'f' : numero:=('05');
               'g' : numero:=('06');
               'h' : numero:=('07');
               'i' : numero:=('08');
               'j' : numero:=('09');
               'k' : numero:=('10');
               'l' : numero:=('11');
               'm' : numero:=('12');
               'n' : numero:=('13');
               'o' : numero:=('14');
               'p' : numero:=('15');
               'q' : numero:=('16');
               'r' : numero:=('17');
               's' : numero:=('18');
               't' : numero:=('19');
               'u' : numero:=('20');
               'v' : numero:=('21');
               'w' : numero:=('22');
               'x' : numero:=('23');
               'y' : numero:=('24');
               'z' : numero:=('25');
               else
               begin
                  	numero:=texto[i];
               end;
          end;
          insert(numero,aux,tam);
          tam:= length(aux)+1;
     end;
     ConverteAscii2Numero:=aux;
end;

// Função que converte o número em texto
function ConverteNumero2Ascii(num: integer):char;
var texto: char;
begin
     case (num) of
          0 : texto:=('a');
          1 : texto:=('b');
          2 : texto:=('c');
          3 : texto:=('d');
          4 : texto:=('e');
          5 : texto:=('f');
          6 : texto:=('g');
          7 : texto:=('h');
          8 : texto:=('i');
          9 : texto:=('j');
          10 : texto:=('k');
          11 : texto:=('l');
          12 : texto:=('m');
          13 : texto:=('n');
          14 : texto:=('o');
          15 : texto:=('p');
          16 : texto:=('q');
          17 : texto:=('r');
          18 : texto:=('s');
          19 : texto:=('t');
          20 : texto:=('u');
          21 : texto:=('v');
          22 : texto:=('w');
          23 : texto:=('x');
          24 : texto:=('y');
          25 : texto:=('z');
     end;
     ConverteNumero2Ascii:=texto;
end;

// Função que escreve a chave para o texto plano
function  IdxChave2Numero(RecebeChave,texto:string;var tam:integer):string;
var postexto,cont,tam3:integer;
    chave:string;
begin   // Recebe a chave no formato de texto, retorna o seu tamanho e o texto da chave convertida
     chave:='';
     cont:=1;
     tam:=length(RecebeChave);// Recebendo o tamanho da chave
     tam3:=length(texto); // Recebendo o tamanho do texto para reescrever a chave várias vezes até completar o tamanho do texto
                          // Ex: Texto Plano: Achamos o Tesouro
                          //     Chave      : naviona v ionavio
     for postexto:= 1 to  tam3 do
         begin
              case texto[postexto] of
              chr(0)..chr(64):insert(texto[postexto],chave,postexto);
              chr(65)..chr(90):begin
                                     insert(RecebeChave[cont],chave,postexto);
                                     inc(cont);
                                end;
              chr(91)..chr(96):insert(texto[postexto],chave,postexto);
              chr(97)..chr(122):begin
                                     insert(RecebeChave[cont],chave,postexto);
                                     inc(cont);
                                end;
              chr(123)..chr(255):insert(texto[postexto],chave,postexto);
              end;
              if (cont = tam+1) then
                 begin  // como a chave sempre sera menor que o texto plano, é necessario reiniciar o cont sempre que ele chegar no tamnho real da chave
                      cont:=1;
                 end;
         end;
     IdxChave2Numero:=chave;
end;

// Função que criptografa o texto plano
function Decripta(chavePlano,textoPlano:string;lengthchave:integer):string;
var chaveNumero,TextoPlanoNumero,auxChave,auxTexto,auxdecripta:string;
    tam,cont,error,auxChaveNumero,auxTextoNumero,auxmodulo,posicao,modtamanhochave:integer;
    letra:char;
    soma:integer;
    			
begin  // Recebe a chave do tipo texto, o texto plano e o tamanho da chave
     ChaveNumero:=ConverteAscii2Numero(chavePlano); // Converte a chave ja na tamanha do texto plano em número
     TextoPlanoNumero:=ConverteAscii2Numero(textoPlano); // Converte o texto em número
     tam:=length(TextoPlano);
     cont:=1;
     error:=0;
     posicao:=0;
     auxdecripta:='';
     soma:=0;
     repeat  // loop que lê caractere por caractere do texto plano e insere em uma outra string
            // o respectivo caractere já decriptado
           inc(posicao);
           case TextoPlanoNumero[cont] of // verifica qual o tipo do caractere na posição cont
                chr(0)..chr(47) :insert(TextoPlanoNumero[cont],auxdecripta,posicao);
 	        chr(48)..chr(57) :begin    // Compara de acordo com a tabela ASCII os números de 0 a 9  Se for número este número será convertido em letra
                                       auxTexto:=copy(textoPlanoNumero,cont,2); // Recebe uma cópia do número do texto plano na posição que está sendo conferida
                                       val(auxTexto,auxTextoNumero,error); // Converte o que foi copiado anteriormente em inteiro
                                       if (error > 0) then
                                          begin
                                                writeln('Erro de conversão');
                                          end;
                                       auxChave:=copy(chaveNumero,cont,2); // Recebe uma cópia referente a chave na mesma posição
                                       val(auxChave,auxChaveNumero,error); // Converte o valor copiado em um inteiro
                                       if (error > 0) then
                                          begin
                                                writeln('Erro de conversão');
                                          end;
                                       modtamanhochave:=Modulo(auxChaveNumero,lengthchave);// Recebe o módulo do número da chave que foi copiado pelo tamanho da chave
                                       soma:=(auxTextoNumero-modtamanhochave);
                                       soma:=soma+26;
                                       {if (soma=255) then
                                       begin
                                       		soma:=25;
                                       end
                                       else if (soma=254) then
                                       begin
                                       		soma:=24;
                                       end;}
                                       
                                       auxmodulo:=Modulo(soma,26);
                                       letra:=ConverteNumero2Ascii(auxmodulo); // Recebe o número encontrado em letra
                                       insert(letra,auxdecripta,posicao); // Insere a letra na variável auxdecripta na posição que está sendo lida
                                       inc(cont);  {Os números são dados sempre de 2 em 2 caracteres, ex: 01 02 03... por isso que sempre quando encontra um número
                                                 na posição cont, o cont será incrementado para que a posição posterior não seja lida novamente}
                                 end;
                // Compara os caracteres especiais de acordo com a tabela ASCII
                chr(58)..chr(64) :insert(TextoPlanoNumero[cont],auxdecripta,posicao);
                chr(91)..chr(97) :insert(TextoPlanoNumero[cont],auxdecripta,posicao);
                chr(123)..chr(255) :insert(TextoPlanoNumero[cont],auxdecripta,posicao);

           end;
	   inc(cont);
     until(posicao=tam);
     decripta:=auxdecripta;
end;

 //Função que imprime o texto descriptografado em um arquivo de saída
procedure ImprimeArquivo(descriptografado:string);
var f2: text;
begin
     assign(f2,ParamStr(3));
     rewrite(f2);
     write(f2,descriptografado);
     close(f2);
end;

var chave,texto,chavePlano,descriptografado: string;
    tamanhochave:integer;

begin
    tamanhochave:=0;
    chave:=RecebeChave();
    texto:=LeArquivo();
    chavePlano:=IdxChave2Numero(chave,texto,tamanhochave);
    descriptografado:=Decripta(chavePlano,texto,tamanhochave);
    ImprimeArquivo(descriptografado);
    textcolor(10);
    writeln('Descriptografado! Arquivo de saída criado com sucesso!');
    textcolor(7);
end.