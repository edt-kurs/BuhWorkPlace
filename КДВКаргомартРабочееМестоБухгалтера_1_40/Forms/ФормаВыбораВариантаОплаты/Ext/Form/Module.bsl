﻿
&НаСервере
Функция ВернутьВариантОплаты(СтрокаВариантаОплаты)
	
	ВариантыОплатВсе = Новый Массив;
	
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	КДВКаргомартВариантыОплатыПеревозки.Ссылка КАК Ссылка
	               |ИЗ
	               |	Перечисление.КДВКаргомартВариантыОплатыПеревозки КАК КДВКаргомартВариантыОплатыПеревозки";
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		
		Если СтрокаВариантаОплаты = Строка(РезультатЗапроса.Ссылка) или СтрокаВариантаОплаты = XMLСтрока(РезультатЗапроса.Ссылка) Тогда
				
				ВариантОплатыСтруктура = Новый Структура;
				ВариантОплатыСтруктура.Вставить("Ссылка", 	РезультатЗапроса.Ссылка);
				ВариантОплатыСтруктура.Вставить("Строка", 	Строка(РезультатЗапроса.Ссылка));
				ВариантОплатыСтруктура.Вставить("Имя", 		XMLСтрока(РезультатЗапроса.Ссылка));
						
				Прервать;
				
		КонецЕсли;		
	
	КонецЦикла;
	
		
	Возврат ВариантОплатыСтруктура;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Параметры.ВариантОплаты) Тогда
		
		ВариантОплаты = ВернутьВариантОплаты(Параметры.ВариантОплаты).Ссылка;
			
	Иначе
		
		ВариантОплаты = Перечисления.КДВКаргомартВариантыОплатыПеревозки.ОплатаПоОригиналам;
		
	КонецЕсли;
	
	ВыбраннаяСтрока = Параметры.ВыбраннаяСтрока; 
	
	РезультатВыполнения = Ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если РезультатВыполнения Тогда
	
		Результат = Новый Структура;
		//Результат.Вставить("ВариантОплаты", 	ПредопределенноеЗначение("Перечисление.КДВКаргомартВариантыОплатыПеревозки." + СтрЗаменить(ВариантОплаты, " ", "")));
		Результат.Вставить("ВариантОплаты", 	Строка(ВариантОплаты));
		Результат.Вставить("ВыбраннаяСтрока", 	ВыбраннаяСтрока);
		
	Иначе
		
		Результат = Неопределено;
		
	КонецЕсли;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры


&НаКлиенте
Процедура Выбрать(Команда)
	
	РезультатВыполнения = Истина;
	
	ЭтаФорма.Закрыть(Ложь);
	
КонецПроцедуры

