﻿
&НаКлиенте
Процедура КСохранить(Команда)
	
	Если ПричинаОтклонения = "" Тогда
		Возврат;
	Иначе
		ЭтаФорма.Закрыть(ПричинаОтклонения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КОтменить(Команда)
	
	ЭтаФорма.Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПричинаОтклоненияПриИзменении(Элементы.ПричинаОтклонения);
КонецПроцедуры

&НаКлиенте
Процедура ПричинаОтклоненияИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Элементы.ФормаКСохранить.Доступность = ЗначениеЗаполнено(Текст);
КонецПроцедуры

&НаКлиенте
Процедура ПричинаОтклоненияПриИзменении(Элемент)
	Элементы.ФормаКСохранить.Доступность = ЗначениеЗаполнено(ПричинаОтклонения);
КонецПроцедуры
