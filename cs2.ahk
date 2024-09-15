#Persistent
#NoEnv
DllCall("timeBeginPeriod", UInt, 1) ; Zamanlayıcı hassasiyetini artırır (1 ms)

; Süreç önceliğini gerçek zaman moduna ayarlayalım
Process, Priority, , R

SetTitleMatchMode, 2  ; Pencere başlığı eşleşmesi modu
SetTitleMatchMode, Fast  ; Daha hızlı eşleşme

; Subtick zamanlamasını sabitleyelim (64 tick rate için)
TICK_64_MS := 15.6  ; 1 tick = 15.6 ms (64 subtick rate için)
exit_key := "End"  ; Scripti sonlandırmak için tuş
activation_key := "xButton1"  ; Mouse 4 tuşu ile aktif hale gelir (FPS oyunları için yaygın)

; --- Sade GUI ---
Gui, Font, s12 Bold cFFFFFF  ; Beyaz renk, kalın yazı fontu
Gui, Add, Text, Center, Açıldı  ; Ortada "Açıldı" yazısını göster
Gui, Color, 000000  ; Arkaplan rengini siyah yap
Gui, Show, Center, CS2 Bhop Script  ; GUI'yi göster

; --- BunnyHop Döngüsü ---
While !GetKeyState(exit_key, "P")  ; End tuşuna basılana kadar çalışır
{
    If GetKeyState(activation_key, "P")  ; Mouse4 tuşuna basılınca bunny hop başlar
    {
        ; Tekerleği aşağı simüle et (mwheeldown)
        MouseClick, WheelDown
        Sleep, % (TICK_64_MS * 1)  ; Bir tick süresi kadar bekle
        
        ; İkinci tekerlek tıklamasını yap ve subtick'e göre süreyi bekle
        MouseClick, WheelDown
        While GetKeyState(activation_key, "P")  ; Mouse4 tuşuna basılı tutma süresince
        {
            MouseClick, WheelDown  ; Her loop'ta mwheeldown simüle edilir
            Sleep, % (TICK_64_MS * 2)  ; İki subtick zamanı kadar bekle
        }
    }
    else
    {
        Sleep, 1  ; Tıklama olmadığı durumda bekle (düşük CPU kullanımı)
    }
}

; Zamanlayıcıyı orijinal ayarlarına geri döndür
DllCall("timeEndPeriod", UInt, 1)
ExitApp  ; Scripti sonlandır
