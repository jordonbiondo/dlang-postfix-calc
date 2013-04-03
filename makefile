DC=dmd
TESTFLAGS=-unittest
RELEASEFLAGS=-release -inline
FLAGS= -O -w
BINDIR=bin
BINNAME=InfixPostfix
TESTNAME=Test_InfixPostfix


default: $(BINDIR)/$(BINNAME);

$(BINDIR)/$(BINNAME): InfixPostfix.d Operator.d StringStack.d
	mkdir -p $(BINDIR); $(DC) $(FLAGS) $(RELEASEFLAGS) -of$(BINDIR)/$(BINNAME) $^


test: $(BINDIR)/$(TESTNAME)

$(BINDIR)/$(TESTNAME): InfixPostfix.d Operator.d StringStack.d
	mkdir -p $(BINDIR);$(DC) $(FLAGS) $(TESTFLAGS) -of$(BINDIR)/$(TESTNAME) $^

clean:
	rm -f *~ $(BINDIR)/*
