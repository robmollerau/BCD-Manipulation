program BCD;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Math,
  System.Classes;

const
  OPTION_EXIT                = '0';
  OPTION_BCD_ENCODE          = '1';
  OPTION_BCD_DECODE          = '2';

function IntToBin( const AValue : Byte ) : String;
var
  AndCompare : Byte;
  Ctr         : Integer;
begin

  SetLength( Result, 8 );

//  for Ctr := 1 to 8 do begin
//    if ( ( Avalue shl ( Ctr - 1 ) ) shr 7 ) = 0 then begin
//      Result[ Ctr ] := '0';
//    end
//    else begin
//      Result[ Ctr ] := '1';
//    end;
//  end;

  for Ctr := 1 to 8 do begin
    AndCompare := Trunc( Power( 2, Ctr - 1 ) );
    if AValue and AndCompare = AndCompare then begin
      Result[ 9 - Ctr ] := '1';
    end
    else begin
      Result[ 9 - Ctr ] := '0';
    end;
  end;

end;

procedure NibblesToByte( const ANibbleLo, ANibbleHi : Byte; var AByte : Byte );
begin
  AByte := ANibbleHi shl 4;
  Abyte := AByte or ( ANibbleLo and 15 );
end;

procedure BCDEncode( const AByte1 : Byte; const AByte2 : Byte; var AByte : Byte );
var
  ANibbleLo,
    ANibbleHi : Byte;
begin

  { Convert char to nibbles }
  if AByte1 in [ 0..9 ] then begin
    ANibbleHi := AByte1;
  end
  else begin
    ANibbleHi := 0;
  end;

  if AByte2 in [ 0..9 ] then begin
    ANibbleLo := AByte2;
  end
  else begin
    ANibbleLo := 0;
  end;

  NibblesToByte( ANibbleLo, ANibbleHi, AByte );

end;

procedure BCDDecode( const ABCDByte : Byte; var AByte1 : Byte; var AByte2 : Byte );
begin
  AByte1 := ABCDByte shr 4;
  AByte2 := ABCDByte and 15;
end;

procedure ExecuteProgram;
var
  Byte1,
    Byte2,
    ByteValue : Byte;
  Ctr,
    PosSpace  : Integer;
  InputValue,
    Input1,
    Input2    : String;
begin

  while True do begin

    WriteLn( '' );
    Write( 'Options: 0-Exit, 1-BCD Encode, 2-BCD Decode : ' );

    ReadLn( InputValue );
    InputValue := Trim( InputValue );

    if InputValue = OPTION_EXIT then begin
      Break;
    end;

    if InputValue = OPTION_BCD_ENCODE then begin

      Write( 'Enter 2 decimal values separated by space (Example: 3 6) : ' );

      ReadLn( InputValue );
      InputValue := Trim( InputValue );

      PosSpace := Pos( ' ', InputValue );

      Input1 := Trim( Copy( InputValue, 1, PosSpace - 1 ) );
      Input2 := Trim( Copy( InputValue, PosSpace + 1, 3 ) );

      BCDEncode( StrToInt( Input2 ), StrToInt( Input1 ), ByteValue );

      WriteLn( 'BCD: ' + IntToStr( ByteValue ) + '  Binary: ' + IntToBin( ByteValue ) );

    end
    else if InputValue = OPTION_BCD_DECODE then begin

      Write( 'Enter decimal value (Example: 153) : ' );

      ReadLn( InputValue );
      InputValue := Trim( InputValue );

      BCDDecode( StrToInt( InputValue ), Byte1, Byte2 );

      WriteLn( 'Value1: ' + IntToStr( Byte2 ) + '  Value2: ' + IntToStr( Byte1 ) );

    end;

  end;

end;

begin

  try
    ExecuteProgram;
  except
    on E: Exception do begin
      WriteLn( E.ClassName, ': ', E.Message );
      ExitCode := 1;
    end;
  end;

end.
