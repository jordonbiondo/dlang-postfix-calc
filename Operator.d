/*
 * Operator.
 * Represents a mathematical operator that performs integer calculations
 * contains precedence data for infix to postfix translations
 */
class Operator {
  /// The mathematical symbol (+, -, ^, ...)
  string symbol;

  /// The input precedence.
  int inputPrecedence;

  /// The stack precedence
  int stackPrecedence;


  /// Operation to be performed given: A *operator* B
  int delegate(int, int) operation;

  /*
   * Constuctor
   */
  this(string symbol, int inputPrecedence, int stackPrecedence, int delegate(int, int) operation) {
    this.symbol = symbol;
    this.inputPrecedence = inputPrecedence;
    this.stackPrecedence = stackPrecedence;
    this.operation = operation;
  }
}

