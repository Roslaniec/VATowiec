#
# How to use:
# ----------
# make clean
# make init    (alternatively: make init0)
# make release
#

.PHONY: all init init0 clean download dogrywka release dirs

VDIR := var
ODIR := out
export DBF_PATH ?= $(VDIR)

RAPORTY := jpk_v7m_3 jpk_v7k_3 jpk_ewp_4 jpk_st_1 fa_3
BAZY    := RAP RW STR
CELE    := $(addprefix $(ODIR)/, $(RAPORTY))
RELEASE := JPK3.zip

$(foreach n, $(RAPORTY),\
    $(foreach r,$(BAZY),\
        $(eval $(n).$(r) := $(ODIR)/$(n).$(r))\
    )\
)

ifeq ($(OS),Windows_NT)
    export PATH := .;$(PATH)
    DBF := dbf
else
    export PATH := .:$(PATH)
    DBF := ./dbf.pl -v
endif

all: $(CELE)

dirs:
	@mkdir -p $(VDIR)
	@mkdir -p $(ODIR)

init: dirs
	$(MAKE) dogrywka

init0: dirs
	$(DBF) query 'delete from XML_RAP'
	$(DBF) query 'delete from XML_RW'
	$(DBF) query 'delete from XML_STR'

clean:
	rm -f $(ODIR)/jpk_* $(ODIR)/fa_*
	rm -f $(ODIR)/$(RELEASE)

download:
	wget -nd -N -P $(VDIR) http://www.vatowiec.pl/pliki/br32v.zip

dogrywka: download
	7z e $(VDIR)/br32v.zip -ba -bb0 -y -o$(VDIR) \
	HELP/XML_RAP.dbf HELP/XML_RW.dbf HELP/XML_STR.dbf

release: all
	cd $(VDIR) && zip ../$(ODIR)/$(RELEASE) *dbf


$(CELE): %: $(addprefix %.,$(BAZY))
	touch $@

# JPK_V7K_3

$(jpk_v7k_3.RAP): jpk_v7k_3.RAP.csv
	$(DBF) query 'delete from XML_RAP where RAP = "JPK_V7K_3"'
	$(DBF) import XML_RAP $<
	touch $@

$(jpk_v7k_3.RW): jpk_v7k_3.RW.csv
	$(DBF) query 'delete from XML_RW where RAP = "JPK_V7K_3"'
	$(DBF) import XML_RW $<
	touch $@

$(jpk_v7k_3.STR): jpk_v7k_3.STR.csv
	$(DBF) query 'delete from XML_STR where ADRES like "JPK_V7K_3\\%"'
	$(DBF) import XML_STR $<
	touch $@

# JPK_V7M_3

$(jpk_v7m_3.RAP): jpk_v7m_3.RAP.csv
	$(DBF) query 'delete from XML_RAP where RAP = "JPK_V7M_3"'
	$(DBF) import XML_RAP $<
	touch $@

$(jpk_v7m_3.RW): jpk_v7m_3.RW.csv
	$(DBF) query 'delete from XML_RW where RAP = "JPK_V7M_3"'
	$(DBF) import XML_RW $<
	touch $@

$(jpk_v7m_3.STR): jpk_v7m_3.STR.csv
	$(DBF) query 'delete from XML_STR where ADRES like "JPK_V7M_3\\%"'
	$(DBF) import XML_STR $<
	touch $@

# JPK_EWP_4

$(jpk_ewp_4.RAP): jpk_ewp_4.RAP.csv
	$(DBF) query 'delete from XML_RAP where RAP = "JPK_EWP_4"'
	$(DBF) import XML_RAP $<
	touch $@

$(jpk_ewp_4.RW): jpk_ewp_4.RW.csv
	$(DBF) query 'delete from XML_RW where RAP = "JPK_EWP_4"'
	$(DBF) import XML_RW $<
	touch $@

$(jpk_ewp_4.STR): jpk_ewp_4.STR.csv
	$(DBF) query 'delete from XML_STR where ADRES like "JPK_EWP_4\\%"'
	$(DBF) import XML_STR $<
	touch $@

# JPK_ST_1

$(jpk_st_1.RAP): jpk_st_1.RAP.csv
	$(DBF) query 'delete from XML_RAP where RAP = "JPK_ST_1"'
	$(DBF) import XML_RAP $<
	touch $@

$(jpk_st_1.RW): 
	touch $@

$(jpk_st_1.STR): jpk_st_1.STR.csv
	$(DBF) query 'delete from XML_STR where ADRES like "JPK_ST_1\\%"'
	$(DBF) import XML_STR $<
	touch $@

# FA_3

$(fa_3.RAP): fa_3.RAP.csv
	$(DBF) query 'delete from XML_RAP where RAP = "FA_3"'
	$(DBF) import XML_RAP $<
	touch $@

$(fa_3.RW): 
	touch $@

$(fa_3.STR): fa_3.STR.csv
	$(DBF) query 'delete from XML_STR where ADRES like "FA_3\\%"'
	$(DBF) import XML_STR $<
	touch $@

# test:
# 	echo $(addprefix $(ODIR)/, $(addprefix jpk_v7k_3.,$(BAZY)))
# 	echo $(addprefix $(ODIR)/jpk_v7k_3.,$(BAZY))
