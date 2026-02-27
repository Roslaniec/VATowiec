#
# How to use:
# ----------
# make init
# make
# make clean
#


.PHONY: all init clean download dogrywka

VDIR := var
TDIR := tmp
export DBF_PATH := $(VDIR)

RAPORTY := jpk_v7m_3 jpk_v7k_3
BAZY    := RAP RW STR
CELE    := $(addprefix $(TDIR)/, $(RAPORTY))

$(foreach n, $(RAPORTY),\
    $(foreach r,$(BAZY),\
        $(eval $(n).$(r) := $(TDIR)/$(n).$(r))\
    )\
)

ifeq ($(OS),Windows_NT)
    export PATH := .;$(PATH)
    DBF := dbf
else
    export PATH := .:$(PATH)
    DBF := ./dbf.pl
endif

all: $(CELE)

init: 
	@mkdir -p $(VDIR)
	@mkdir -p $(TDIR)
	$(MAKE) dogrywka

clean:
	rm -f $(TDIR)/jpk*

download:
	wget -nd -N -P $(VDIR) http://www.vatowiec.pl/pliki/br32v.zip

dogrywka: download
	7z e $(VDIR)/br32v.zip -ba -bb0 -y -o$(VDIR) \
	HELP/XML_RAP.dbf HELP/XML_RW.dbf HELP/XML_STR.dbf

$(CELE): %: $(addprefix %.,$(BAZY))
	touch $@

# $(TDIR)/jpk_v7k_3: $(addprefix $(TDIR)/jpk_v7k_3.,$(BAZY))
# 	touch $@

$(jpk_v7k_3.RAP): jpk_v7k_3.RAP.csv
	$(DBF) query 'delete from XML_RAP where RAP = "JPK_V7K_3"'
	$(DBF) import XML_RAP $<
	touch $@

$(jpk_v7m_3.RAP): jpk_v7m_3.RAP.csv
	$(DBF) query 'delete from XML_RAP where RAP = "JPK_V7M_3"'
	$(DBF) import XML_RAP $<
	touch $@

$(jpk_v7k_3.RW): jpk_v7k_3.RW.csv
	$(DBF) query 'delete from XML_RW where RAP = "JPK_V7K_3"'
	$(DBF) import XML_RW $<
	touch $@

$(jpk_v7m_3.RW): jpk_v7m_3.RW.csv
	$(DBF) query 'delete from XML_RW where RAP = "JPK_V7M_3"'
	$(DBF) import XML_RW $<
	touch $@

$(jpk_v7k_3.STR): jpk_v7k_3.STR.csv
	$(DBF) query 'delete from XML_STR where ADRES like "JPK_V7K_3\\%"'
	$(DBF) import XML_STR $<
	touch $@

$(jpk_v7m_3.STR): jpk_v7m_3.STR.csv
	$(DBF) query 'delete from XML_STR where ADRES like "JPK_V7M_3\\%"'
	$(DBF) import XML_STR $<
	touch $@

test:
	echo $(addprefix $(TDIR)/, $(addprefix jpk_v7k_3.,$(BAZY)))
	echo $(addprefix $(TDIR)/jpk_v7k_3.,$(BAZY))
