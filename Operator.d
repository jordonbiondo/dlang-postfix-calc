import std.stdio;
import std.array;
import std.conv;
import std.container;

// /////////////////////////////////////////////////////////////////
//   Operator
// /////////////////////////////////////////////////////////////////
class Operator {
  string symbol;
  int inputPrecedence;
  int stackPrecedence;
  int delegate(int a, int b) operation;

  this(string symbol, int inputPrecedence, int stackPrecedence, int delegate(int, int) operation) {
    this.symbol = symbol;
    this.inputPrecedence = inputPrecedence;
    this.stackPrecedence = stackPrecedence;
    this.operation = operation;
  }
}


// /////////////////////////////////////////////////////////////////
//   String Stack
// /////////////////////////////////////////////////////////////////
class StringStack {

  private string[] stack;

  this() {
    stack = new string[0];
  }

  public void push(string s) {
    stack.insertInPlace(0, s);
  }

  public string peek() {
    return stack.front();
  }

  public string pop() {
    string r = stack.front();
    stack.popFront();
    return r;
  }

  public string[] getStack() {
    return stack;
  }

}

class InfixPostfix {
  Operator[string] operators;

  this() {
    operators = [
		 "+": new Operator("+", 1, 1, (a, b) => to!int(a) + to!int(b)),
		 "-": new Operator("-", 1, 1, (a, b) => to!int(a) - to!int(b)),
		 "*": new Operator("*", 2, 2, (a, b) => to!int(a) * to!int(b)),
		 "/": new Operator("/", 2, 2, (a, b) => to!int(a) / to!int(b)),
		 "%": new Operator("%", 2, 2, (a, b) => to!int(a) % to!int(b)),
		 "^": new Operator("^", 4, 3, (a, b) => to!int(a) ^^ to!int(b)),
		 "(": new Operator("(", 5, -1, null)];


  }

  /*
   * Infix To Postfix
   */
  public string infixToPostfix(string exprStr) {
    StringStack stack = new StringStack();
    StringStack expression = new StringStack();
    return exprStr;
  }


  /*
   * Evaluate Postfix expression
   */
  public int evaluatePostfix(string exprStr) {
    StringStack stack = new StringStack();
    return 0;
  }

  /*
   * Is Operator
   */
  public bool isOperator(string str) {
    return true;
  }

}



// /////////////////////////////////////////////////////////////////
//   Main
// /////////////////////////////////////////////////////////////////
void main() {
  Operator lp = new Operator("(", 1 , 3, null);
  Operator plus = new Operator("(", 1 , 3, (int a, int b) => a + b);
  writeln(plus.operation(10, 22));
  InfixPostfix ifpf = new InfixPostfix();
  writeln(ifpf.operators["^"].operation(22, 4));

}


