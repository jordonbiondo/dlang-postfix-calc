import std.stdio;
import std.array;
import std.container;

class Operator {
  string symbol;
  int inputPrecedence;
  int stackPrecedence;

  this(string symbol, int inputPrecedence, int stackPrecedence) {
    this.symbol = symbol;
    this.inputPrecedence = inputPrecedence;
    this.stackPrecedence = stackPrecedence;
  }
}


void main() {
  Operator x = new Operator("(", 1 , 3);
  writeln(x.symbol);
  auto b = ["10", "+", "11"];
  b.insertInPlace(0, "df");
  b.popFront();

  writeln(b);
}


