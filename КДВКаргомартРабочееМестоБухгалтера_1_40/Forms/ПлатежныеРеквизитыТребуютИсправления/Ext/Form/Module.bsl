﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//КВВ++ 2022.03.01
	//Было:
	//Если НЕ (ЗначениеЗаполнено(Параметры.НомерЗаказаКаргомарт) И ЗначениеЗаполнено(Параметры.Организация)) Тогда
	//Стало:
	Если НЕ (ЗначениеЗаполнено(Параметры.НомерЗаказаКаргомарт) И ЗначениеЗаполнено(Параметры.Организация) И ЗначениеЗаполнено(Параметры.ЗаказКаргомарт)) Тогда
		
		//Ругань о незаполненных параметрах
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	Объект.Организация 		= Параметры.Организация;
	НомерЗаказаКаргомарт 	= Параметры.НомерЗаказаКаргомарт;
	ЗаказКаргомарт 			= Параметры.ЗаказКаргомарт;
	
	Если ЗаполнитьПлатежныеРеквизитыИзЗРДС_ПоЗаказуКаргомарт() = Ложь Тогда
		
		Отказ = Истина;
		Сообщить("Не удалось получить данные платежных реквизитов заявки на оплату по казаку Каргомарт " + НомерЗаказаКаргомарт);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПлатежныеРеквизитыИзЗРДС_ПоЗаказуКаргомарт()
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(КДВКаргомартЗаказ.ДокументЗРДСОплатаПеревозчику.СчетКонтрагента.НомерСчета, """") КАК ДокументЗРДСОплатаПеревозчикуСчетКонтрагентаНомерСчета,
	|	ЕСТЬNULL(КДВКаргомартЗаказ.ДокументЗРДСОплатаПеревозчику.СчетКонтрагента.Банк.Код, """") КАК ДокументЗРДСОплатаПеревозчикуСчетКонтрагентаБанкКод,
	|	ЕСТЬNULL(КДВКаргомартЗаказ.ДокументЗРДСОплатаПеревозчику.СчетКонтрагента.БанкДляРасчетов.КоррСчет, ЕСТЬNULL(КДВКаргомартЗаказ.ДокументЗРДСОплатаПеревозчику.СчетКонтрагента.Банк.КоррСчет, """")) КАК ДокументЗРДСОплатаПеревозчикуСчетКонтрагентаБанкДляРасчетовКоррСчет,
	|	КДВКаргомартЗаказ.ДокументЗРДСОплатаПеревозчику КАК ДокументЗРДСОплатаПеревозчику,
	|	КДВКаргомартДлинныеСтроки.Значение КАК ДетальнаяИнформация
	|ИЗ
	|	Документ.КДВКаргомартЗаказ КАК КДВКаргомартЗаказ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КДВКаргомартДлинныеСтроки КАК КДВКаргомартДлинныеСтроки
	|		ПО КДВКаргомартЗаказ.Ссылка = КДВКаргомартДлинныеСтроки.Объект
	|			И (КДВКаргомартДлинныеСтроки.Свойство = &СвойствоДополнительнаяИнформация)
	|ГДЕ
	|	КДВКаргомартЗаказ.Ссылка = &ЗаказКаргомарт
	|	И КДВКаргомартЗаказ.Организация = &Организация";
	Запрос.УстановитьПараметр("СвойствоДополнительнаяИнформация", КДВКаргомартКлиентСервер.ИмяДСДетальнаяИнформация());
	Запрос.УстановитьПараметр("ЗаказКаргомарт", ЗаказКаргомарт);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Выборка.ДокументЗРДСОплатаПеревозчику) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	БИК 			= Выборка.ДокументЗРДСОплатаПеревозчикуСчетКонтрагентаБанкКод;
	НомерСчета 		= Выборка.ДокументЗРДСОплатаПеревозчикуСчетКонтрагентаНомерСчета;
	НомерКоррСчета 	= Выборка.ДокументЗРДСОплатаПеревозчикуСчетКонтрагентаБанкДляРасчетовКоррСчет;
	
	ДетальнаяИнформация = КДВКаргомартКлиентСервер.ЗначениеИзJSON(Выборка.ДетальнаяИнформация);
	
	БИКВЗаказеКМ 			= ДетальнаяИнформация.proposal.carrier.bankingDetails.bic;
	НомерСчетаВЗаказеКМ 	= ДетальнаяИнформация.proposal.carrier.bankingDetails.operatingAccount;
	НомерКоррСчетаВЗаказеКМ = ДетальнаяИнформация.proposal.carrier.bankingDetails.correspondingAccount;
	
	Если СокрЛП(БИК) <> СокрЛП(БИКВЗаказеКМ) Тогда
		Элементы.ДкБикВЗаказе.Заголовок 			= "В заказе: " + СокрЛП(БИКВЗаказеКМ);
	КонецЕсли;
	
	Если СокрЛП(НомерСчета) <> СокрЛП(НомерСчетаВЗаказеКМ) Тогда
		Элементы.ДкНомерСчетаВЗаказе.Заголовок 		= "В заказе: " + СокрЛП(НомерСчетаВЗаказеКМ);
	КонецЕсли;
	
	Если СокрЛП(НомерКоррСчета) <> СокрЛП(НомерКоррСчетаВЗаказеКМ) Тогда
		Элементы.ДкНомерКоррСчетаВЗаказе.Заголовок 	= "В заказе: " + СокрЛП(НомерКоррСчетаВЗаказеКМ);
	КонецЕсли;
	
	ИДЗаказаКаргомарт = ДетальнаяИнформация.proposal.id;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура КОтправитьВКаргомарт(Команда)
	
	Результат = КОтправитьВКаргомартНаСервере();
	
	Если Результат.КодОшибки <> 0 Тогда
		
		Сообщить(Результат.Лог);
		ПоказатьПредупреждение(,"Операция не выполнена", 10, "Ошибка");
		Возврат;
		
	КонецЕсли;
	
	ЭтаФорма.Закрыть(Истина);
	
КонецПроцедуры

&НаСервере
Функция КОтправитьВКаргомартНаСервере()
	
	СтруктураОтправляемыеПараметры = Новый Структура;
	СтруктураОтправляемыеПараметры.Вставить("ИДЗаказаКаргомарт", 		ИДЗаказаКаргомарт);
	СтруктураОтправляемыеПараметры.Вставить("БИКВЗаказеКМ", 			БИКВЗаказеКМ);
	СтруктураОтправляемыеПараметры.Вставить("КомментарийБИК", 			КомментарийБИК);
	СтруктураОтправляемыеПараметры.Вставить("НомерСчетаВЗаказеКМ", 		НомерСчетаВЗаказеКМ);
	СтруктураОтправляемыеПараметры.Вставить("КомментарийНомерСчета", 	КомментарийНомерСчета);
	СтруктураОтправляемыеПараметры.Вставить("НомерКоррСчетаВЗаказеКМ", 	НомерКоррСчетаВЗаказеКМ);
	СтруктураОтправляемыеПараметры.Вставить("КомментарийНомерКоррСчета",КомментарийНомерКоррСчета);
	
	//+++ 2022.03.17 Конинин В.В.
	//Было:
	//Возврат КДВКаргомартСервер.ПометитьБанковскиеРеквизитыОшибочными(Объект.Организация, ЗаказКаргомарт, СтруктураОтправляемыеПараметры);
	//Стало:
	Возврат КДВКаргомартСервер.ПометитьБанковскиеРеквизитыОшибочными(ЗаказКаргомарт, СтруктураОтправляемыеПараметры);
	
КонецФункции
