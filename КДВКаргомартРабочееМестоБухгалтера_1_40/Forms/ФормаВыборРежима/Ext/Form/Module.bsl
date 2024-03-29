﻿
&НаКлиенте
Процедура КнОК(Команда)
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимРаботы", 	РежимРаботы);
	ПараметрыОткрытия.Вставить("Протокол", 		Протокол);
	
	ОткрытьФорму("ВнешняяОбработка.КДВКаргоМартРабочееМестоБухгалтера.Форма.ФормаСпискаЗаказовКаргоМарт", ПараметрыОткрытия);
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьКоманду(ИдентификаторКоманды) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимРаботы", 	?(СтрНайти(ИдентификаторКоманды, "ПроверкаСканов") > 0, 0, 1));
	ПараметрыОткрытия.Вставить("Протокол", 		?(СтрНайти(ИдентификаторКоманды, "Протокол_V1") > 0, 	1, 2));
	
	ОткрытьФорму("ВнешняяОбработка.КДВКаргоМартРабочееМестоБухгалтера.Форма.ФормаСпискаЗаказовКаргоМарт", ПараметрыОткрытия,,ИдентификаторКоманды);
	
	Если ЭтаФорма.Открыта() Тогда
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры
