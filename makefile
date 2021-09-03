# ============================================================================ #
# user variables setup.
# feel free to adjust to your requirements

# ---------------------------------------------------------------------------- #
# Compiler setup

CXX      = g++
CXXFLAGS = -std=c++2a -O3 -Wextra -Wall -Wpedantic -Wimplicit-fallthrough -I $(LIBDIR)
LDFLAGS  = -lm

LIBDIR = lib
SRCDIR = src
INCDIR = inc
OBJDIR = obj
EXEDIR = .

# ---------------------------------------------------------------------------- #
# Project Data setup

EXTENSION_CODE   = .cpp
EXTENSION_HEADER = .hpp

MAINMODULE = main

LIBNAME = libtest
EXENAME = lib_link_test

# ---------------------------------------------------------------------------- #
# Runtime setup

RUNTIME_PARAM = ""

# ============================================================================ #
# Setup. Be sure that you really understand what you're don't if you edit
# anything below this line

DIRECTORIES = $(subst $(SRCDIR),$(OBJDIR),$(shell find $(SRCDIR) -type d)) $(LIBDIR)
	# paths for files to be included into the compile/link procedure.
	# subst: "substitute PARAMETER_1 by PARAMETER_2 in PARAMETER_3.
	# shell find -type d lists only directories. find works recursively.
	# => load from SRCDIR and OBJDIR with all subdirectories

SRC     = $(wildcard $(SRCDIR)/*$(EXTENSION_CODE)) $(wildcard $(SRCDIR)/**/*$(EXTENSION_CODE))
	# list of all files in src, including subdirectories
INC     = $(wildcard $(INCDIR)/*$(EXTENSION_HEADER)) $(wildcard $(INCDIR)/**/*$(EXTENSION_HEADER))
	# same for includes
OBJ     = $(SRC:$(SRCDIR)/%$(EXTENSION_CODE)=$(OBJDIR)/%.o)
	# defines analogy relation?

LIBOBJECTS = $(subst $(OBJDIR)/$(MAINMODULE).o,, $(OBJ))
	# create a list of object files that are to be used for library linkage
MAINOBJECT = $(OBJDIR)/$(MAINMODULE).o

# ---------------------------------------------------------------------------- #
# Color constants

COLOR_END	= \033[m

COLOR_RED	= \033[0;31m
COLOR_GREEN	= \033[0;32m
COLOR_YELLOW	= \033[0;33m
COLOR_BLUE	= \033[0;34m
COLOR_PURPLE	= \033[0;35m
COLOR_CYAN	= \033[0;36m
COLOR_GREY	= \033[0;37m

COLOR_LRED	= \033[1;31m
COLOR_LGREEN	= \033[1;32m
COLOR_LYELLOW	= \033[1;33m
COLOR_LBLUE	= \033[1;34m
COLOR_LPURPLE	= \033[1;35m
COLOR_LCYAN	= \033[1;36m
COLOR_LGREY	= \033[1;37m

MSG_OK		= $(COLOR_LGREEN)[SUCCES]$(COLOR_END)
MSG_WARNING	= $(COLOR_LYELLOW)[WARNING]$(COLOR_END)
MSG_ERROR	= $(COLOR_LRED)[ERROR]$(COLOR_END)

# ============================================================================ #
# procs

define fatboxtop
	@printf "$(COLOR_BLUE)"
	@printf "#=============================================================================#\n"
	@printf "$(COLOR_END)"
endef
# ............................................................................ #
define fatboxbottom
	@printf "$(COLOR_BLUE)"
	@printf "#=============================================================================#\n"
	@printf "$(COLOR_END)"
endef
# ............................................................................ #
define fatboxtext
	@printf "$(COLOR_BLUE)"
	@printf "# "
	@printf "$(COLOR_LGREY)"
	@printf "%-75b %s" $(1)
	@printf "$(COLOR_BLUE)"
	@printf "#\n"
	@printf "$(COLOR_END)"

endef
# ---------------------------------------------------------------------------- #
define boxtop
	@printf "$(COLOR_BLUE)"
	@printf "+-----------------------------------------------------------------------------+\n"
	@printf "$(COLOR_END)"
endef
# ............................................................................ #
define boxbottom
	@printf "$(COLOR_BLUE)"
	@printf "+-----------------------------------------------------------------------------+\n"
	@printf "$(COLOR_END)"
endef
# ............................................................................ #
define boxtext
	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LGREY)"
	@printf "%-75b %s" $(1)
	@printf "$(COLOR_BLUE)"
	@printf "|\n"
	@printf "$(COLOR_END)"
endef
# ---------------------------------------------------------------------------- #
define fatbox
	$(call fatboxtop)
	$(call fatboxtext, $(1))
	$(call fatboxbottom)
endef
# ............................................................................ #
define box
	$(call boxtop)
	$(call boxtext, $(1))
	$(call boxbottom)
endef

# ============================================================================ #
# targets

default:
	@clear
	@echo "This makefile supports the following targets:"
	@echo "$(COLOR_YELLOW)Compile and link targets$(COLOR_END)"
	@echo "* $(COLOR_LCYAN)clean$(COLOR_END)"
	@echo "   removes $(OBJDIR) and its contents."

	@echo "* $(COLOR_LCYAN)compile$(COLOR_END)"
	@echo "   creates .o files from all changed sources."
	@echo "* $(COLOR_LCYAN)new$(COLOR_END)"
	@echo "   compiles all files, regardless of whether they may have changed since the last time this was run"

	@echo "* $(COLOR_LCYAN)lib-static$(COLOR_END)"
	@echo "   creates a .a file from all .o files except for main.o."
	@echo "* $(COLOR_LCYAN)lib-shared$(COLOR_END)"
	@echo "   creates a .so file from all .o files except for main.o."
	@echo "* $(COLOR_LCYAN)lib$(COLOR_END)"
	@echo "   invokes both, lib-static and lib-shared"

	@echo "* $(COLOR_LCYAN)full-static$(COLOR_END)"
	@echo "   creates an executable with static linkage and main module $(MAINMODULE).$(EXTENSION_CODE)"
	@echo "* $(COLOR_LCYAN)full-shared$(COLOR_END)"
	@echo "   creates an executable with dynamic linkage and main module $(MAINMODULE).$(EXTENSION_CODE)"

	@echo "$(COLOR_YELLOW)Execution targets$(COLOR_END)"
	@echo "* $(COLOR_LCYAN)run-static$(COLOR_END)"
	@echo "   creates an executable with static linkage and executes it"
	@echo "   invokes make full-static"
	@echo "* $(COLOR_LCYAN)run-shared$(COLOR_END)"
	@echo "   creates an executable with dynamic linkage and executes it"
	@echo "   invokes make full-shared"
	@echo "* $(COLOR_LCYAN)run$(COLOR_END)"
	@echo "   creates an executable with dynamic linkage and executes it"
	@echo "   same as make run-shared"

	@echo ""
	@echo "$(COLOR_YELLOW)Info targets$(COLOR_END)"
	@echo "* $(COLOR_LCYAN)vars$(COLOR_END)"
	@echo "   show variables generated and set by this script"
	@echo "* $(COLOR_LCYAN)default$(COLOR_END)"
	@echo "   show this help"
	@echo ""

	@echo "Note that you can create compound targets such as:"
	@echo "   $(COLOR_LCYAN)make clean run$(COLOR_END)"

# ---------------------------------------------------------------------------- #
# compound targets

compile:  intro $(OBJ) extro
new:      clean intro compile extro

lib-static: intro $(LIBDIR)/$(LIBNAME).a extro
lib-shared: intro $(LIBDIR)/$(LIBNAME).so extro
lib:        intro $(LIBDIR)/$(LIBNAME).a $(LIBDIR)/$(LIBNAME).so extro

full-static: intro full-static-main extro
full-dynamic: intro full-dynamic-main extro

# all:      intro generate extro
# run:      intro generate extro execute

# ---------------------------------------------------------------------------- #
# visual feedback

intro:
	@clear
	$(call fatbox, "attempting to make")
	@printf "$(COLOR_GREY)  "
	@date
	@echo ""

# ............................................................................ #
extro:
	$(call fatbox, "make done")
	@printf "$(COLOR_GREY)  "
	@date
	@echo ""

# --------------------------------------------------------------------------- #
# delete the object directory

clean:
	@printf "$(COLOR_LCYAN)"
	@echo "#=============================================================================#"
	@echo "# attempting to clean...                                                      #"

	@rm -rf $(OBJDIR)
	@rm -f $(EXEDIR)/$(EXENAME)
	@rm -f $(LIBDIR)/$(LIBNAME).*

	@echo "# done.                                                                       #"
	@echo "#=============================================================================#"
	@echo ""

# ---------------------------------------------------------------------------- #
# compilation

$(OBJDIR)/%.o: $(SRCDIR)/%$(EXTENSION_CODE)
	$(call boxtop)
	$(call boxtext, "attempting to compile...")

	@mkdir -p $(DIRECTORIES)

	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-85b %s" "  Compiling:  $(COLOR_LYELLOW)$<$(COLOR_END)"
	@printf "$(COLOR_BLUE)|\n"

	@$(CXX) $(CXXFLAGS) -c -fPIC $< -o $@ -I $(INCDIR) \
		|| (echo "$(MSG_ERROR)"; exit 1)

	$(call boxtext, "done.")
	$(call boxtop)



# --------------------------------------------------------------------------- #
# library packers

$(LIBDIR)/$(LIBNAME).a: $(LIBOBJECTS)
	$(call boxtop)
	$(call boxtext, "attempting to link static library...")

	@mkdir -p $(LIBDIR)

	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-85b %s" "  Linking:  $(COLOR_LYELLOW)$<$(LIBNAME).a$(COLOR_END)"
	@printf "$(COLOR_BLUE)|\n"

	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "%-74b %s " "ar rcs $(LIBDIR)/$(LIBNAME).a $(LIBOBJECTS)"
	@printf "$(COLOR_BLUE)|\n"

	@ar rcs $(LIBDIR)/$(LIBNAME).a $(LIBOBJECTS)

	$(call boxtext, "done.")
	$(call boxbottom)

# ............................................................................ #

$(LIBDIR)/$(LIBNAME).so: $(LIBOBJECTS)
	$(call boxtop)
	$(call boxtext, "attempting to link dynamic library...")

	@mkdir -p $(LIBDIR)

	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-85b %s" "  Linking:  $(COLOR_LYELLOW)$<$(LIBNAME).so$(COLOR_END)"
	@printf "$(COLOR_BLUE)|\n"

	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "%-74b %s " "$(CXX) $(LIBOBJECTS) -shared -o $(LIBDIR)/$(LIBNAME).so"
	@printf "$(COLOR_BLUE)|\n"

	@$(CXX) $(LIBOBJECTS) -shared -o $(LIBDIR)/$(LIBNAME).so

	$(call boxtext, "done.")
	$(call boxbottom)

# ---------------------------------------------------------------------------- #
# executable linkers

full-static-main: $(OBJ) $(LIBDIR)/$(LIBNAME).a
	$(call boxtop)
	$(call boxtext, "attempting to link statically...")

	@mkdir -p $(EXEDIR)

	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-85b %s" "  Linking:  $(COLOR_LYELLOW)$(EXENAME)$(COLOR_END)"

	@$(CXX) $(OBJDIR)/$(MAINMODULE).o $(LIBDIR)/$(LIBNAME).a  -o $(EXEDIR)/$(EXENAME) $(LDFLAGS) \
		|| (echo "$(MSG_ERROR)"; exit 1)

	@printf "$(COLOR_BLUE)"
	@printf "|\n"

	$(call box, "done")

# ............................................................................ #

full-dynamic-main: $(OBJ) $(LIBDIR)/$(LIBNAME).so
	$(call boxtop)
	$(call boxtext, "attempting to link dynamically...")

	@mkdir -p $(EXEDIR)

	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-85b %s" "  Linking:  $(COLOR_LYELLOW)$(EXENAME)$(COLOR_END)"
	@printf "$(COLOR_BLUE)|\n"

	@$(CXX) $(OBJDIR)/$(MAINMODULE).o $(LIBDIR)/$(LIBNAME).so  -o $(EXEDIR)/$(EXENAME) $(LDFLAGS) \
		|| (echo "$(MSG_ERROR)"; exit 1)

	@printf "$(COLOR_BLUE)"
	@printf "|\n"

	$(call box, "done")

# ---------------------------------------------------------------------------- #
# help section

vars :
	@clear
	$(call fatbox, "variables dump:")

	@echo "source code extension    : $(EXTENSION_CODE)"
	@echo "header files extension   : $(EXTENSION_HEADER)"
	@echo ""
	@echo "executable file name     : $(EXENAME)"
	@echo "library file name base   : $(LIBNAME)"
	@echo ""
	@echo "source code  directory   : $(SRCDIR)"
	@echo "include file directory   : $(INCDIR)"
	@echo "object file  directory   : $(OBJDIR)"
	@echo "library      directory   : $(LIBDIR)"
	@echo "binary       directory   : $(EXEDIR)"
	@echo ""

	@echo "binary source directories: $(DIRECTORIES)"
	@echo "source code files         :"
	@echo "   $(SRC)"
	@echo "header files              :"
	@echo "   $(INC)"
	@echo "object code files         :"
	@echo "   '$(OBJ)'"
	@echo "library object code files :"
	@echo "   '$(LIBOBJECTS)'"
	@echo "main object code file     :"
	@echo "   '$(MAINOBJECT)'"
	@echo ""

	$(call fatbox, "done.")
# ............................................................................ #
