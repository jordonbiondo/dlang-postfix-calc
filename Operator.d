import std.stdio;
import std.array;
import std.conv;
import std.container;
import std.algorithm;
import std.regex;

// /////////////////////////////////////////////////////////////////
//   Operator
// /////////////////////////////////////////////////////////////////
class Operator {
  string symbol;
  int inputPrecedence;
  int stackPrecedence;
  //int delegate(int a, int b) operation;
  int delegate(int, int) operation;

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
    return  reduce!((a, b) => a ~ b ~ " ")("", expression.stack);
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
  private bool isOperator(string str) {
    return ! find(operators.keys, str).empty;
  }

  private bool isOperand(string str) {
    return ! match(str, regex("^[0-9]+$")).empty;
  }

  private bool isLeftParen(string str) {
    return str == "(";
  }

  private bool isRightParen(string str) {
    return str == "(";
  }

  private int stackPrecedence(string operator) {
    return operators[operator].stackPrecedence;
  }

  private int inputPrecedence(string operator) {
    return operators[operator].inputPrecedence;
  }

  private int applyOperator(string num1, string num2, string  operator) {
    return operators[operator].operation(to!int(num1), to!int(num2));
  }

  unittest {
    InfixPostfix ifpf = new InfixPostfix;
    assert(2 == ifpf.applyOperator("1", "1", "+"));
    assert(2 == ifpf.applyOperator("29", "10", "/"));
    assert(0 == ifpf.applyOperator("10", "29", "/"));
    assert(16 == ifpf.applyOperator("4", "2", "^"));
    assert(2 == ifpf.applyOperator("4", "2", "-"));
    assert(2 == ifpf.applyOperator("18", "8", "%"));
    assert(16 == ifpf.applyOperator("2", "8", "*"));
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
  writeln("(" == " (");
  writeln(reduce!((a, b) => a ~ b ~ " ")("", ["a", "b", "c", "d"]));
  writeln(ifpf.isOperand("102"));
  writeln(ifpf.isOperator("^"));
  writeln(ifpf.applyOperator("23","10","/"));

}


