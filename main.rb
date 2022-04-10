require 'date'

#Zero a esquerda hora
def zeroLeft(frase)
    if frase.length < 5
        frase = "0" + frase
        return frase
    end
    return frase
end

# RegEx para hashtag
def hashRegEx(frase)
    hash = frase.scan(/\#[a-zA-Zà-úÀ-Ú0-9]*/)
    hashString = "Tag: "
    hash.each do |w|
      hashString += w.to_s + " "
    end
    return hashString
end

# RegEx para horário
def horarioRegEx(frase)
    horaString = "Horário: "
    #10:30
    if(!!(frase =~ /([0-9]{2}:[0-9]{2})/i))
        reghora = frase.match(/(\d{1,2}:?\s?\d{2})/).to_s
        return horaString + reghora
    #10 30
    elsif(!!(frase =~ /[0-9]{2}\s[0-9]{2}/i))
        reghora = frase.match(/(\d{1,2}\s?\d{2})/).to_s
        reghora.gsub! ' ', ':'
        return horaString + reghora
    #10 horas | 1 hora
    elsif(!!(frase =~ /[0-9]{1,2}\shora/i))
        reghora = frase.match(/[0-9]{1,2}\shora/).to_s
        reghora[" hora"] = ":00"
        reghora = zeroLeft(reghora)
        return horaString + reghora
    #às 10
    else
        reghora = frase.match(/(?<= às\s)[0-9]{1,2}/).to_s
        reghora = zeroLeft(reghora + ":00")
        return horaString + reghora
    end
end

# RegEx para pegar as pessoas
def pessoasRegEx(frase)
    # Pegar a primeira pessoa
    pessoa = frase.match(/(?<= [cC]om\s)[a-zA-Zà-úÀ-Ú]*/)
    stringPessoas = "Pessoas: " + pessoa.to_s + " "
    # Caso tenha mais de uma pessoa, pegar o resto
    pessoas = frase.scan(/(?<=\se\s|\,\s)[A-Z][a-zà-úÀ-Ú]+/)
    pessoas.each do |p|
      stringPessoas += p.to_s + " "
    end
    return stringPessoas
end

def validateMonth(string)
    meses = {
    1=>"Janeiro",
    2=>"Fevereiro",
    3=>"Março",
    4=>"Abril",
    5=>"Maio",
    6=>"Junho",
    7=>"Julho",
    8=>"Agosto",
    9=>"Setembro",
    10=>"Outubro",
    11=>"Novembro",
    12=>"Dezembro"
}
    dia = string.match(/[1-9]{2}/).to_s
    mes = meses.index(string.match(/(?<= de\s)[a-zA-Z]+/).to_s)
    ano = string.match(/[0-9]{4}/).to_s
    # Caso for ex: 23 de fev, pega o ano atual, se não, ano dado
    if ano.empty?
        ano =  Date.today.year
    end
    # Caso o mes for abaixo de 10, colocar o 0 na frente
    if mes < 10
        mes = "0#{mes}"
    end
    data = "#{dia}/#{mes}/#{ano}"
    return data
end

# RegEx para pegar a data
def dataRegEx(frase)
    # 10 de Janeiro de 2021
    if(!!(frase =~ /[1-9]{2} de [a-zA-Z]+ de [0-9]{4}/i))
        regdata = frase.match(/[1-9]{2} de [a-zA-Z]+ de [0-9]{4}/).to_s
        data = validateMonth(regdata)
    # 10 de Janeiro
    elsif(!!(frase =~ /([1-9]{2} de [a-zA-Z]+)/i))
        regdata = frase.match(/([1-9]{2} de [a-zA-Z]+)/).to_s
        data = validateMonth(regdata)
    # Mostrar data de hoje
    elsif frase.include? "hoje"
        data = Date.today().strftime("%d/%m/%Y")
    # Mostrar data de depois de amanhã
    elsif frase.include? "depois de amanhã"
        data = (Date.today() + 2).strftime("%d/%m/%Y")
    # Mostrar data de amanhã 
    elsif frase.include? "amanhã"
        data = (Date.today() + 1).strftime("%d/%m/%Y")
    # Datas só com dia e mês
    elsif(!!(frase =~ /([0-9]{2}\/[0-9]{2})/i))
        regdata = frase.match(/([0-9]{2}\/[0-9]{2})/).to_s
        data = regdata + "/#{Date.today.year}"
    # Pega a data dada pela frase com ano
    else
       data = frase.match(/([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))\/\d{4}/)
    end
    return "Data: "+data.to_s 
end


def usarRegExs(frase)
    puts "Frase: "+ frase
    puts hashRegEx(frase)
    puts horarioRegEx(frase)
    puts pessoasRegEx(frase)
    puts dataRegEx(frase)
    puts
end

puts "Olá, quer digitar uma frase(0) ou ver os exemplos(1)?"
resposta = gets.chomp
case resposta
    when '0'
        puts "Digite a frase: "
        fraseUser = gets.chomp
        usarRegExs(fraseUser)
    else '1'
        exemplo1 = "Agendar com José e Maria reunião às 10 dia 28/09/2022 #trabalho #faculdade"
        usarRegExs(exemplo1)
    
        exemplo2 = "Agendar com José, Carlos e Roberta reunião 2 horas, 28 de Fevereiro de 3024 #trabalho #faculdade"
        usarRegExs(exemplo2)
        
        exemplo3 = "Agendar com Adalberto e Roberta reunião 10 30, no dia 28 de Fevereiro #trabalho #faculdade"
        usarRegExs(exemplo3)
        
        exemplo4 = "Agendar com Ana reunião 10:45, 20/01 #trabalho #faculdade"
        usarRegExs(exemplo4)
        
        exemplo5 = "Agendar com Antonio reunião 09:45, depois de amanhã  #trabalho #faculdade"
        usarRegExs(exemplo5)
        
        exemplo6 = "Agendar com Chris reunião 13 45, depois de amanhã  #trabalho #faculdade"
        usarRegExs(exemplo6)
        
        exemplo7 = "Agendar com Rodolfo reunião às 11, amanhã #trabalho #faculdade"
        usarRegExs(exemplo7)
        
        exemplo8 = "Agendar com Walter reunião 23:54, hoje #faculdade"
        usarRegExs(exemplo8)
end
