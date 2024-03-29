# ��� ���������� ������� ��� ����������� ����� ������ Griliches �� ������ Ecdat. ����� ���������� ������ �� ���������� ����� � ���� ������ ����������� ��� 758 ������� (���, 1980 ���). ������ �����, ��� ����� ������������ ����� ������, ��� sandwich, lmtest, car, dplyr, broom � ggplot2.
library('devtools')
install_github('bdemeshev/sophisthse')
library(lubridate)  # ������ � ������
library(sandwich)  # vcovHC, vcovHAC
library(lmtest)  # �����
library(car)  # ��� �����
library(zoo)  # ��������� ����
library(xts)  # ��� ����
library(broom)  # ����������� � ��������
library(estimatr) # ������ � ���������� ������������ ��������
library(tidyverse) # ������� � ����������� � �������, ������������ ������ dplyr, ggplot2, etc
library(quantmod)  # �������� � finance.google.com
library(rusquant)  # �������� � finam.ru
library(sophisthse)  # �������� � sophist.hse.ru
library(Quandl)  # �������� � Quandl

# Q11:�������� ����� ������� ������ ����������� �������� (��� ���������� ����� ������������� ��� 1980 ����, ������� ������ ���������� lw80) 
# �� �������� (age80), ������������ ���������� (iq), ����������� (school80, ���������� ��������� � �����, ��������������� � �� ����), � ����� ������ (expr80).
# ������� �������������� ������� ������������� ���������. � ����� ������� ���������� ����� iq � expr80.
# ����������: �������� ��������, ��� R ������� ����� ��������� ����� � ������� 1.234567e-08, ����� ����� ������ � ����� �� �������!

d11 <-Griliches
glimpse(d11)
model11 <- lm(data=d11,lw80~age80+iq+school80+expr80) 
vcov(model11)

# Q12: ������� �������������� ������� ������������� ���������, ���������� � ��������������������, ���� HC3. 
# �������� � ���������� �� ���������� ����.
# � ����� ������� ������ ��������� ���������� ����� iq � expr80 (
# ���������� � ������� ������� ����� ���������� � ���������� � �������������������� �������, � �� ��� �� ������).
vcovHC(model11,type = "HC3")
abs(-2.651401e-07 - -3.101489e-07)

# Q13: ��������� �������� ������ ������ �������������� �������. 
# ��� ����� �� ���� ����� ������ ����������� ������ ��� age80 ����� ����� �������?
vcovHC(model11,type = "HC0")
coeftest(model11,vcov. = vcovHC(model,type="HC0"))
coeftest(model11,vcov. = vcovHC(model,type="HC1"))
coeftest(model11,vcov. = vcovHC(model,type="HC2"))
coeftest(model11,vcov. = vcovHC(model,type="HC3"))

# Q14:�������� ������� �������������������� � ����� ������ ��� ������ ����� ������-������. 
# �����������, ��� ������� �������� ������� ������ �� ������������ ���������� 
# (�� iq, ������ �� ���� � � ������ �������, ��� ���������). ����� �������� �������� ���������� �� �������?
bptest(model11, varformula = ~ 1 +iq, data = d11)

# Q15: �������� ������� �������������������� � ����� ������ ��� ������ ����� ����������-�������. 
# �����������, ��� ������� �������� ������� �� ������������ ����������(iq), ���������� ����� 20% ����������. 
# ����� �������� �������� ���������� �� �������?
gqtest(model11, order.by = ~iq, data = d11, fraction = 0.2)

# ��� ���������� ������� ��� ����������� ������, �������������� � ������� ������ 6, 
# � ����� ����� ������ Solow (������������ ����� ������, ��� ���������� ������� ������ �� �������, ������ �������� � ������ ���������� � ��� � 1909 - 1949 ��.) �� ������ Ecdat.
# Q16: ������� ������ ����������� ������ ������� (q) �� �������� (k) � ���������� (A). 
# ������� ������� �������������� ������� � �������, ���������� � �������������������� � ��������������.
# ��������� ���������� ������ ��������� ���������? 
# � ����� ������� ������ �������� ������ ��� ������� � ���������� � �������������������� � �������������� ������.
# ����������: �������� ��������, ��� R ������� ����� ��������� ����� � ������� 1.234567e-08, 
# ����� ����� ������ � ����� �� �������!
d16 <-  Solow
glimpse(d16)
model16 <- lm(data=d16, q~k+A)
vcov(model16)
vcovHAC(model16)
abs(8.759004e-05 - 9.204408e-05)

# Q17:������� ������ ����������� ������ ������� (q) �� �������� (k) � ���������� (A). 
# ��������� ���� �������-�������. ���� ����� �������� �������� ���������� (���������� �������-�������)?
dwt(model16)

# Q18: ������� ������ ����������� ������ ������� (q) �� �������� (k) � ���������� (A). 
# ��������� ���� ������-������ � ������������ �������� ����������, ������ 3. 
# ���� ����� �������� �������� ����������?
res <- bgtest(model16, order = 3)
res$statistic

# Q19: ����� ������������������ ������ �������� ��������� ����� ������?
Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "GOOG",from="2010-01-01", to="2014-02-03",src="yahoo")
plot(GOOG$GOOG.Close, main = "")

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "AAPL",from="2010-01-01", to="2014-02-03",src="yahoo")
plot(AAPL$AAPL.Close, main = "")

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "INTC",from="2010-01-01", to="2014-02-03",src="yahoo")
plot(INTC$INTC.Close, main = "")

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "MSFT",from="2010-01-01", to="2014-02-03",src="yahoo")
plot(MSFT$MSFT.Close, main = "")

# Q20: �� ������ ������ ��� ��� ��������� ��������� ������� �� ����������� �������:
Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "GOOG",from="2010-01-01", to="2014-02-03",src="yahoo")
# � (��� ��������) ��������� ���� �������� ����� Google (GOOG$GOOG.Close) � ��������� ����������, � ������� �� � ����� ������ ��������. 
# ������� ��������� ���� �� ��� � ���� (������� � ����������� ��������). � ����� ������� R^2
# ���� ������ ����������� �� ���� ������ ����� �������.
# ����������: ���� � ��� ���������� GOOG.Close � GOOG.Close.1, ����������� ������ GOOG.Close
y <- GOOG$GOOG.Close
y_t1 <- stats::lag(y, -1)  
y_t2 <- stats::lag(y, -2) 

model20 <- lm(y~y_t1+y_t2)
summary(model20)
