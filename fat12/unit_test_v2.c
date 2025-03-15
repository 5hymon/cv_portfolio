/*
 * Unit Test Bootstrap
 * Autor: Tomasz Jaworski, 2018-2020
 *
 * Test dla zadania Projekt: czytnik dysku, woluminu, katalogu głównego i plików (3,0)
 * Autor testowanej odpowiedzi: Szymon Kobus-Puchała
 * Test wygenerowano automatycznie o 2024-10-09 22:22:11.618160
 *
 * Debug: 
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <signal.h>
#include <setjmp.h>
#include <assert.h>

#if !defined(__clang__) && !defined(__GNUC__)
// Zakomentuj poniższy błąd, jeżeli chcesz przetestować testy na swoim kompilatorze C.
#error System testow jednostkowych jest przeznaczony dla kompilatorów GCC/Clang.
#endif

#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
// Zakomentuj poniższy błąd, jeżeli chcesz przetestować testy na platformie Windows.
#error System testow jednostkowych NIE jest przeznaczony dla testów uruchamianych na platformach Windows.
#endif

#define _RLDEBUG_API_
#include "unit_helper_v2.h"
#include "rdebug.h"

#include "tested_declarations.h"
#include "rdebug.h"

//
// Elementy globalne dla całego testu
//




//
//  Test 1: Sprawdzanie poprawności działania funkcji disk_open_from_file
//
void UTEST1(void)
{
    // informacje o teście
    test_start(1, "Sprawdzanie poprawności działania funkcji disk_open_from_file", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    


            struct disk_t* disk = disk_open_from_file("ONE.TX");
            test_error(disk == NULL, "Funkcja disk_open_from_file() powinna zwrócić NULL przy próbie otwarcia nieistniejącego pliku");

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 2: Sprawdzanie poprawności działania funkcji disk_open_from_file
//
void UTEST2(void)
{
    // informacje o teście
    test_start(2, "Sprawdzanie poprawności działania funkcji disk_open_from_file", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    


            struct disk_t* disk = disk_open_from_file(NULL);
            test_error(disk == NULL, "Funkcja disk_open_from_file() powinna zwrócić NULL przy próbie otwarcia nieistniejącego pliku");

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 3: Sprawdzanie poprawności działania funkcji disk_close
//
void UTEST3(void)
{
    // informacje o teście
    test_start(3, "Sprawdzanie poprawności działania funkcji disk_close", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    


            disk_close(NULL);
      
            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 4: Sprawdzanie poprawności działania funkcji fat_open
//
void UTEST4(void)
{
    // informacje o teście
    test_start(4, "Sprawdzanie poprawności działania funkcji fat_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    


            struct disk_t* disk = disk_open_from_file("silent.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume == NULL, "Funkcja fat_open() powinna zwrócić NULL w przypadku przekazania błędnego obrazu dysku");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 5: Sprawdzanie poprawności działania funkcji disk_open_from_file
//
void UTEST5(void)
{
    // informacje o teście
    test_start(5, "Sprawdzanie poprawności działania funkcji disk_open_from_file", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            struct volume_t* volume = fat_open(NULL, 0);
            test_error(volume == NULL, "Funkcja fat_open() powinna zwrócić NULL w przypadku przekazania błędnego obrazu dysku");

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 6: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST6(void)
{
    // informacje o teście
    test_start(6, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
        
                char *filecontent = (char *)calloc(2560, 1);
                char expected_filecontent[2561] = "";
        
                strcat(expected_filecontent, "round, who shines with sister lamp\nTo his, that glisters yonder,\" and I show\'d\nThe sun.  \"Tis he, who through profoundest night\nOf he true dead has brought me, with this flesh\nAs true, that follows.  From that gloom the aid\nOf his sure comfort drew me on to climb,\nAnd climbing wind along this mountain-steep,\nWhich rectifies in you whate\'er the world\nMade crooked and deprav\'d I have his word,\nThat he will bear me company as far\nAs till I come where Beatrice dwells:\nBut there must leave me.  Virgil is that spirit,\nWho thus hath promis\'d,\"  and I pointed to him;\n\"The other is that shade, for whom so late\nYour realm, as he arose, exulting shook\nThrough every pendent cliff and rocky bound.\"\n\n\n\nCANTO XXIV\n\nOur journey was not slacken\'d by our talk,\nNor yet our talk by journeying.  Still we spake,\nAnd urg\'d our travel stoutly, like a ship\nWhen the wind sits astern.  The shadowy forms,\nThat seem\'d things dead and dead again, drew in\nAt their deep-delved orbs rare wonder of me,\nPerceiving I had life; and I my words\nContinued, and thus spake; \"He journeys up\nPerhaps more tardily then else he would,\nFor others\' sake.  But tell me, if thou know\'st,\nWhere is Piccarda?  Tell me, if I see\nAny of mark, among this multitude,\nWho eye me thus.\"--\"My sister (she for whom,\n\'Twixt beautiful and good I cannot say\nWhich name was fitter ) wears e\'en now her crown,\nAnd triumphs in Olympus.\"  Saying this,\nHe added: \"Since spare diet hath so worn\nOur semblance out, \'t is lawful here to name\nEach one .   This,\" and his finger then he rais\'d,\n\"Is Buonaggiuna,--Buonaggiuna, he\nOf Lucca: and that face beyond him, pierc\'d\nUnto a leaner fineness than the rest,\nHad keeping of the church: he was of Tours,\nAnd purges by wan abstinence away\nBolsena\'s eels and cups of muscadel.\"\n     He show\'d me many others, one by one,\nAnd all, as they were nam\'d, seem\'d well content;\nFor no dark gesture I discern\'d in any.\nI saw through hunger Ubaldino grind\nHis teeth on emptiness; and Boniface,\nThat wav\'d the crozier o\'er a num\'rous flock.\nI saw the Marquis, who tad time erewhile\nTo swill at Forli with less drought, yet so\nWas one ne\'er sated.  I howe\'er, like him,\nThat gazing \'midst a crowd, singles out one,\nSo singled him of Lucca; for methought\nWas none amongst them took such note of me.\nSomewhat I heard him whisper of Gentucca:\nThe sound was indistinct, and murmur\'d there,\nWhere justice, that so strips them, fix\'d her sting.\n     \"Spirit!\" said I, \"it seems as thou wouldst fain\nSpeak with me.  Let me hear thee.  Mutual wish\nTo converse prompts, which let us both");
                
        
                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct file_t* file = file_open(volume, "COVER.TXT");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                size_t size = file_read(filecontent, 1, 2560, file);
                test_error(size == 2560, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2560 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 2560);
            
                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));
            
                onerror_compare_memory(expected_filecontent, filecontent, 2560);


                free(filecontent);
        
                file_close(file);
                fat_close(volume);
                disk_close(disk);
        
                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 7: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST7(void)
{
    // informacje o teście
    test_start(7, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
        
                char *filecontent = (char *)calloc(260, 1);
                char expected_filecontent[261] = "";
        
                strcat(expected_filecontent, "ere mark\'d I Helen, for whose sake so long\nThe time was fraught with evil; there the great\nAchilles, who with love fought to the end.\nParis I saw, and Tristan; and beside\nA thousand more he show\'d me, and by name\nPointed them out, whom love bereav\'d of life.\n ");
                
        
                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct file_t* file = file_open(volume, "OUT");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                size_t size = file_read(filecontent, 1, 260, file);
                test_error(size == 260, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 260 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 260);
            
                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));
            
                onerror_compare_memory(expected_filecontent, filecontent, 260);


                free(filecontent);
        
                file_close(file);
                fat_close(volume);
                disk_close(disk);
        
                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 8: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST8(void)
{
    // informacje o teście
    test_start(8, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
        
                char *filecontent = (char *)calloc(2634, 1);
                char expected_filecontent[2635] = "";
        
                strcat(expected_filecontent, "  To shun\nAll human converse, here she with her slaves\nPlying her arts remain\'d, and liv\'d, and left\nHer body tenantless.  Thenceforth the tribes,\nWho round were scatter\'d, gath\'ring to that place\nAssembled; for its strength was great, enclos\'d\nOn all parts by the fen.  On those dead bones\nThey rear\'d themselves a city, for her sake,\nCalling it Mantua, who first chose the spot,\nNor ask\'d another omen for the name,\nWherein more numerous the people dwelt,\nEre Casalodi\'s madness by deceit\nWas wrong\'d of Pinamonte.  If thou hear\nHenceforth another origin assign\'d\nOf that my country, I forewarn thee now,\nThat falsehood none beguile thee of the truth.\"\n     I answer\'d:  \"Teacher, I conclude thy words\nSo certain, that all else shall be to me\nAs embers lacking life.  But now of these,\nWho here proceed, instruct me, if thou see\nAny that merit more especial note.\nFor thereon is my mind alone intent.\"\n     He straight replied:  \"That spirit, from whose cheek\nThe beard sweeps o\'er his shoulders brown, what time\nGraecia was emptied of her males, that scarce\nThe cradles were supplied, the seer was he\nIn Aulis, who with Calchas gave the sign\nWhen first to cut the cable.  Him they nam\'d\nEurypilus:  so sings my tragic strain,\nIn which majestic measure well thou know\'st,\nWho know\'st it all.  That other, round the loins\nSo slender of his shape, was Michael Scot,\nPractis\'d in ev\'ry slight of magic wile.\n     \"Guido Bonatti see:   Asdente mark,\nWho now were willing, he had tended still\nThe thread and cordwain; and too late repents.\n     \"See next the wretches, who the needle left,\nThe shuttle and the spindle, and became\nDiviners:  baneful witcheries they wrought\nWith images and herbs.  But onward now:\nFor now doth Cain with fork of thorns confine\nOn either hemisphere, touching the wave\nBeneath the towers of Seville.  Yesternight\nThe moon was round.  Thou mayst remember well:\nFor she good service did thee in the gloom\nOf the deep wood.\"  This said, both onward mov\'d.\n\n\n\nCANTO XXI\n\nTHUS we from bridge to bridge, with other talk,\nThe which my drama cares not to rehearse,\nPass\'d on; and to the summit reaching, stood\nTo view another gap, within the round\nOf Malebolge, other bootless pangs.\n     Marvelous darkness shadow\'d o\'er the place.\n     In the Venetians\' arsenal as boils\nThrough wintry months tenacious pitch, to smear\nTheir unsound vessels; for th\' inclement time\nSea-faring men restrains, and in that while\nHis bark one builds anew, another stops\nThe ribs of his, that hath made many a voyage;\nOne hammers at the prow, one at the poop;\nThis shapeth oars, that other cables twirls,\nThe mizen one repairs and main");
                
        
                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct file_t* file = file_open(volume, "OPERATE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                size_t size = file_read(filecontent, 1, 2634, file);
                test_error(size == 2634, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2634 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 2634);
            
                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));
            
                onerror_compare_memory(expected_filecontent, filecontent, 2634);


                free(filecontent);
        
                file_close(file);
                fat_close(volume);
                disk_close(disk);
        
                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 9: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST9(void)
{
    // informacje o teście
    test_start(9, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
        
                char *filecontent = (char *)calloc(2464, 1);
                char expected_filecontent[2465] = "";
        
                strcat(expected_filecontent, "nder Godfrey of Bouillon, (Maimbourg, Hist.\ndes Croisades, ed. Par. 1682. 12mo. t. i. p. 96.) but rather the\ntwo more celebrated heroes in the age of Charlemagne.  The\nformer, William l. of Orange, supposed to have been the founder\nof the present illustrious family of that name, died about 808,\naccording to Joseph de la Piser, Tableau de l\'Hist. des Princes\net Principante d\'Orange. Our countryman, Ordericus Vitalis,\nprofesses to give his true life, which had been misrepresented in\nthe songs of the itinerant bards.\"  Vulgo canitur a joculatoribus\nde illo, cantilena; sed jure praeferenda est relatio\nauthentica.\"  Eccl.  Hist.  in Duchesne, Hist.  Normann Script.\np.  508. The latter is better known by having been celebrated by\nAriosto, under the name of Rinaldo.\n\nv. 43.  Duke Godfey.]  Godfrey of Bouillon.\n\nv. 46.  Robert Guiscard.]  See Hell, Canto XXVIII. v. 12.\n\nv. 81.  The characters.]  Diligite justitiam qui judicatis\nterrarm. \"Love righteousness, ye that be judges of the earth \"\nWisdom of  Solomon, c. i. 1.\n\nv. 116.  That once more.]  \"That he may again drive out those who\nbuy and sell in the temple.\"\n\nv. 124.  Taking the bread away.]  \"Excommunication, or the\ninterdiction of the Eucharist, is now employed as a weapon of\nwarfare.\"\n\nv. 126.  That writest but to cancel.]  \"And thou, Pope Boniface,\nwho writest thy ecclesiastical censures for no other purpose than\nto be  paid for revoking them.\"\n\nv. 130.  To him.]  The coin of Florence was stamped with the\nimpression of John the Baptist.\n\nCANTO XIX\n\nv. 38.  Who turn\'d his compass.]  Compare Proverbs, c. viii.  27.\nAnd Milton, P. L. b. vii 224.\n\nv. 42.  The Word]  \"The divine nature still remained\nincomprehensible. Of this Lucifer was a proof; for had he\nthoroughly comprehended it, he would not have fallen.\"\n\nv. 108.  The Ethiop.]  Matt.  c. xii.  41.\n\nv. 112.  That volume.]  Rev. c. xx.  12.\n\nv. 114.  Albert.]  Purgatory, Canto VI.  v. 98.\n\nv. 116.  Prague.]  The eagle predicts the devastation of Bohemia\nby Albert, which happened soon after this time, when that Emperor\nobtained the kingdom for his eldest son Rodolph.  See Coxe\'s\nHouse of Austria, 4to.  ed. v. i. part 1. p. 87\n\nv. 117.  He.]  Philip IV of France, after the battle of Courtrai,\n1302, in which the French were defeated by the Flemings, raised\nthe nominal value of the coin.  This king died in consequence of\nhis horse being thrown to the ground by a wild boar, in 1314\n\nv. 121.  The English and Scot.]  He adverts");
                
        
                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct file_t* file = file_open(volume, "EQUATE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                size_t size = file_read(filecontent, 1, 2464, file);
                test_error(size == 2464, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2464 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 2464);
            
                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));
            
                onerror_compare_memory(expected_filecontent, filecontent, 2464);


                free(filecontent);
        
                file_close(file);
                fat_close(volume);
                disk_close(disk);
        
                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 10: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST10(void)
{
    // informacje o teście
    test_start(10, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
        
                char *filecontent = (char *)calloc(3960, 1);
                char expected_filecontent[3961] = "";
        
                strcat(expected_filecontent, "eyes glar\'d wheeling flames.  Meanwhile\nThose spirits, faint and naked, color chang\'d,\nAnd gnash\'d their teeth, soon as the cruel words\nThey heard.  God and their parents they blasphem\'d,\nThe human kind, the place, the time, and seed\nThat did engender them and give them birth.\n     Then all together sorely wailing drew\nTo the curs\'d strand, that every man must pass\nWho fears not God.  Charon, demoniac form,\nWith eyes of burning coal, collects them all,\nBeck\'ning, and each, that lingers, with his oar\nStrikes.  As fall off the light autumnal leaves,\nOne still another following, till the bough\nStrews all its honours on the earth beneath;\nE\'en in like manner Adam\'s evil brood\nCast themselves one by one down from the shore,\nEach at a beck, as falcon at his call.\n     Thus go they over through the umber\'d wave,\nAnd ever they on the opposing bank\nBe landed, on this side another throng\nStill gathers.  \"Son,\" thus spake the courteous guide,\n\"Those, who die subject to the wrath of God,\nAll here together come from every clime,\nAnd to o\'erpass the river are not loth:\nFor so heaven\'s justice goads them on, that fear\nIs turn\'d into desire.  Hence ne\'er hath past\nGood spirit.  If of thee Charon complain,\nNow mayst thou know the import of his words.\"\n     This said, the gloomy region trembling shook\nSo terribly, that yet with clammy dews\nFear chills my brow.  The sad earth gave a blast,\nThat, lightening, shot forth a vermilion flame,\nWhich all my senses conquer\'d quite, and I\nDown dropp\'d, as one with sudden slumber seiz\'d.\n\n\n\nCANTO IV\n\nBROKE the deep slumber in my brain a crash\nOf heavy thunder, that I shook myself,\nAs one by main force rous\'d.  Risen upright,\nMy rested eyes I mov\'d around, and search\'d\nWith fixed ken to know what place it was,\nWherein I stood.  For certain on the brink\nI found me of the lamentable vale,\nThe dread abyss, that joins a thund\'rous sound\nOf plaints innumerable.  Dark and deep,\nAnd thick with clouds o\'erspread, mine eye in vain\nExplor\'d its bottom, nor could aught discern.\n     \"Now let us to the blind world there beneath\nDescend;\" the bard began all pale of look:\n\"I go the first, and thou shalt follow next.\"\n     Then I his alter\'d hue perceiving, thus:\n\"How may I speed, if thou yieldest to dread,\nWho still art wont to comfort me in doubt?\"\n     He then:  \"The anguish of that race below\nWith pity stains my cheek, which thou for fear\nMistakest.  Let us on.  Our length of way\nUrges to haste.\"  Onward, this said, he mov\'d;\nAnd ent\'ring led me with him on the bounds\nOf the first circle, that surrounds th\' abyss.\nHere, as mine ear could note, no plaint was heard\nExcept of sighs, that made th\' eternal air\nTremble, not caus\'d by tortures, but from grief\nFelt by those multitudes, many and vast,\nOf men, women, and infants.  Then to me\nThe gentle guide:  \"Inquir\'st thou not what spirits\nAre these, which thou beholdest?  Ere thou pass\nFarther, I would thou know, that these of sin\nWere blameless; and if aught they merited,\nIt profits not, since baptism was not theirs,\nThe portal to thy faith.  If they before\nThe Gospel liv\'d, they serv\'d not God aright;\nAnd among such am I. For these defects,\nAnd for no other evil, we are lost;\nOnly so far afflicted, that we live\nDesiring without hope.\"  So grief assail\'d\nMy heart at hearing this, for well I knew\nSuspended in that Limbo many a soul\nOf mighty worth.  \"O tell me, sire rever\'d!\nTell me, my master!\"  I began through wish\nOf full assurance in that holy faith,\nWhich vanquishes all error; \"say, did e\'er\nAny, or through his own or other\'s merit,\nCome forth from thence, whom afterward was blest?\"\n     Piercing the secret purport of my speech,\nHe answer\'d: \"I was new to that estate,\nWhen I beheld a puissant one arrive\nAmongst us, with victorious trophy crown\'d.\nHe forth the shade of our first parent drew,\nAbel his child, and Noah righteous man,\nOf Moses lawgiver for faith approv\'d,\nOf patriarch Abraham, and David king,\nIsrael with his sire and ");
                
        
                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct file_t* file = file_open(volume, "WHEEL");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                size_t size = file_read(filecontent, 1, 3960, file);
                test_error(size == 3960, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 3960 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 3960);
            
                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));
            
                onerror_compare_memory(expected_filecontent, filecontent, 3960);


                free(filecontent);
        
                file_close(file);
                fat_close(volume);
                disk_close(disk);
        
                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 11: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST11(void)
{
    // informacje o teście
    test_start(11, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
        
                char *filecontent = (char *)calloc(34, 1);
                char expected_filecontent[35] = "";
        
                strcat(expected_filecontent, "stings the piteous only feel),\nSo ");
                
        
                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                struct file_t* file = file_open(volume, "MINEDESE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
                size_t size = file_read(filecontent, 1, 34, file);
                test_error(size == 34, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 34 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 34);
            
                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));
            
                onerror_compare_memory(expected_filecontent, filecontent, 34);


                free(filecontent);
        
                file_close(file);
                fat_close(volume);
                disk_close(disk);
        
                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 12: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST12(void)
{
    // informacje o teście
    test_start(12, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char *filecontent = (char *)calloc(2560, 1);
                char expected_filecontent[2561] = "";

                strcat(expected_filecontent, "round, who shines with sister lamp\nTo his, that glisters yonder,\" and I show\'d\nThe sun.  \"Tis he, who through profoundest night\nOf he true dead has brought me, with this flesh\nAs true, that follows.  From that gloom the aid\nOf his sure comfort drew me on to climb,\nAnd climbing wind along this mountain-steep,\nWhich rectifies in you whate\'er the world\nMade crooked and deprav\'d I have his word,\nThat he will bear me company as far\nAs till I come where Beatrice dwells:\nBut there must leave me.  Virgil is that spirit,\nWho thus hath promis\'d,\"  and I pointed to him;\n\"The other is that shade, for whom so late\nYour realm, as he arose, exulting shook\nThrough every pendent cliff and rocky bound.\"\n\n\n\nCANTO XXIV\n\nOur journey was not slacken\'d by our talk,\nNor yet our talk by journeying.  Still we spake,\nAnd urg\'d our travel stoutly, like a ship\nWhen the wind sits astern.  The shadowy forms,\nThat seem\'d things dead and dead again, drew in\nAt their deep-delved orbs rare wonder of me,\nPerceiving I had life; and I my words\nContinued, and thus spake; \"He journeys up\nPerhaps more tardily then else he would,\nFor others\' sake.  But tell me, if thou know\'st,\nWhere is Piccarda?  Tell me, if I see\nAny of mark, among this multitude,\nWho eye me thus.\"--\"My sister (she for whom,\n\'Twixt beautiful and good I cannot say\nWhich name was fitter ) wears e\'en now her crown,\nAnd triumphs in Olympus.\"  Saying this,\nHe added: \"Since spare diet hath so worn\nOur semblance out, \'t is lawful here to name\nEach one .   This,\" and his finger then he rais\'d,\n\"Is Buonaggiuna,--Buonaggiuna, he\nOf Lucca: and that face beyond him, pierc\'d\nUnto a leaner fineness than the rest,\nHad keeping of the church: he was of Tours,\nAnd purges by wan abstinence away\nBolsena\'s eels and cups of muscadel.\"\n     He show\'d me many others, one by one,\nAnd all, as they were nam\'d, seem\'d well content;\nFor no dark gesture I discern\'d in any.\nI saw through hunger Ubaldino grind\nHis teeth on emptiness; and Boniface,\nThat wav\'d the crozier o\'er a num\'rous flock.\nI saw the Marquis, who tad time erewhile\nTo swill at Forli with less drought, yet so\nWas one ne\'er sated.  I howe\'er, like him,\nThat gazing \'midst a crowd, singles out one,\nSo singled him of Lucca; for methought\nWas none amongst them took such note of me.\nSomewhat I heard him whisper of Gentucca:\nThe sound was indistinct, and murmur\'d there,\nWhere justice, that so strips them, fix\'d her sting.\n     \"Spirit!\" said I, \"it seems as thou wouldst fain\nSpeak with me.  Let me hear thee.  Mutual wish\nTo converse prompts, which let us both");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "COVER.TXT");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                size_t size = file_read(filecontent, 1, 2684, file);
                test_error(size == 2560, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2560 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 2560);

                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));

                onerror_compare_memory(expected_filecontent, filecontent, 2560);


                free(filecontent);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 13: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST13(void)
{
    // informacje o teście
    test_start(13, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char *filecontent = (char *)calloc(260, 1);
                char expected_filecontent[261] = "";

                strcat(expected_filecontent, "ere mark\'d I Helen, for whose sake so long\nThe time was fraught with evil; there the great\nAchilles, who with love fought to the end.\nParis I saw, and Tristan; and beside\nA thousand more he show\'d me, and by name\nPointed them out, whom love bereav\'d of life.\n ");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "OUT");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                size_t size = file_read(filecontent, 1, 378, file);
                test_error(size == 260, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 260 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 260);

                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));

                onerror_compare_memory(expected_filecontent, filecontent, 260);


                free(filecontent);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 14: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST14(void)
{
    // informacje o teście
    test_start(14, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char *filecontent = (char *)calloc(2634, 1);
                char expected_filecontent[2635] = "";

                strcat(expected_filecontent, "  To shun\nAll human converse, here she with her slaves\nPlying her arts remain\'d, and liv\'d, and left\nHer body tenantless.  Thenceforth the tribes,\nWho round were scatter\'d, gath\'ring to that place\nAssembled; for its strength was great, enclos\'d\nOn all parts by the fen.  On those dead bones\nThey rear\'d themselves a city, for her sake,\nCalling it Mantua, who first chose the spot,\nNor ask\'d another omen for the name,\nWherein more numerous the people dwelt,\nEre Casalodi\'s madness by deceit\nWas wrong\'d of Pinamonte.  If thou hear\nHenceforth another origin assign\'d\nOf that my country, I forewarn thee now,\nThat falsehood none beguile thee of the truth.\"\n     I answer\'d:  \"Teacher, I conclude thy words\nSo certain, that all else shall be to me\nAs embers lacking life.  But now of these,\nWho here proceed, instruct me, if thou see\nAny that merit more especial note.\nFor thereon is my mind alone intent.\"\n     He straight replied:  \"That spirit, from whose cheek\nThe beard sweeps o\'er his shoulders brown, what time\nGraecia was emptied of her males, that scarce\nThe cradles were supplied, the seer was he\nIn Aulis, who with Calchas gave the sign\nWhen first to cut the cable.  Him they nam\'d\nEurypilus:  so sings my tragic strain,\nIn which majestic measure well thou know\'st,\nWho know\'st it all.  That other, round the loins\nSo slender of his shape, was Michael Scot,\nPractis\'d in ev\'ry slight of magic wile.\n     \"Guido Bonatti see:   Asdente mark,\nWho now were willing, he had tended still\nThe thread and cordwain; and too late repents.\n     \"See next the wretches, who the needle left,\nThe shuttle and the spindle, and became\nDiviners:  baneful witcheries they wrought\nWith images and herbs.  But onward now:\nFor now doth Cain with fork of thorns confine\nOn either hemisphere, touching the wave\nBeneath the towers of Seville.  Yesternight\nThe moon was round.  Thou mayst remember well:\nFor she good service did thee in the gloom\nOf the deep wood.\"  This said, both onward mov\'d.\n\n\n\nCANTO XXI\n\nTHUS we from bridge to bridge, with other talk,\nThe which my drama cares not to rehearse,\nPass\'d on; and to the summit reaching, stood\nTo view another gap, within the round\nOf Malebolge, other bootless pangs.\n     Marvelous darkness shadow\'d o\'er the place.\n     In the Venetians\' arsenal as boils\nThrough wintry months tenacious pitch, to smear\nTheir unsound vessels; for th\' inclement time\nSea-faring men restrains, and in that while\nHis bark one builds anew, another stops\nThe ribs of his, that hath made many a voyage;\nOne hammers at the prow, one at the poop;\nThis shapeth oars, that other cables twirls,\nThe mizen one repairs and main");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "OPERATE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                size_t size = file_read(filecontent, 1, 2801, file);
                test_error(size == 2634, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2634 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 2634);

                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));

                onerror_compare_memory(expected_filecontent, filecontent, 2634);


                free(filecontent);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 15: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST15(void)
{
    // informacje o teście
    test_start(15, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char *filecontent = (char *)calloc(2464, 1);
                char expected_filecontent[2465] = "";

                strcat(expected_filecontent, "nder Godfrey of Bouillon, (Maimbourg, Hist.\ndes Croisades, ed. Par. 1682. 12mo. t. i. p. 96.) but rather the\ntwo more celebrated heroes in the age of Charlemagne.  The\nformer, William l. of Orange, supposed to have been the founder\nof the present illustrious family of that name, died about 808,\naccording to Joseph de la Piser, Tableau de l\'Hist. des Princes\net Principante d\'Orange. Our countryman, Ordericus Vitalis,\nprofesses to give his true life, which had been misrepresented in\nthe songs of the itinerant bards.\"  Vulgo canitur a joculatoribus\nde illo, cantilena; sed jure praeferenda est relatio\nauthentica.\"  Eccl.  Hist.  in Duchesne, Hist.  Normann Script.\np.  508. The latter is better known by having been celebrated by\nAriosto, under the name of Rinaldo.\n\nv. 43.  Duke Godfey.]  Godfrey of Bouillon.\n\nv. 46.  Robert Guiscard.]  See Hell, Canto XXVIII. v. 12.\n\nv. 81.  The characters.]  Diligite justitiam qui judicatis\nterrarm. \"Love righteousness, ye that be judges of the earth \"\nWisdom of  Solomon, c. i. 1.\n\nv. 116.  That once more.]  \"That he may again drive out those who\nbuy and sell in the temple.\"\n\nv. 124.  Taking the bread away.]  \"Excommunication, or the\ninterdiction of the Eucharist, is now employed as a weapon of\nwarfare.\"\n\nv. 126.  That writest but to cancel.]  \"And thou, Pope Boniface,\nwho writest thy ecclesiastical censures for no other purpose than\nto be  paid for revoking them.\"\n\nv. 130.  To him.]  The coin of Florence was stamped with the\nimpression of John the Baptist.\n\nCANTO XIX\n\nv. 38.  Who turn\'d his compass.]  Compare Proverbs, c. viii.  27.\nAnd Milton, P. L. b. vii 224.\n\nv. 42.  The Word]  \"The divine nature still remained\nincomprehensible. Of this Lucifer was a proof; for had he\nthoroughly comprehended it, he would not have fallen.\"\n\nv. 108.  The Ethiop.]  Matt.  c. xii.  41.\n\nv. 112.  That volume.]  Rev. c. xx.  12.\n\nv. 114.  Albert.]  Purgatory, Canto VI.  v. 98.\n\nv. 116.  Prague.]  The eagle predicts the devastation of Bohemia\nby Albert, which happened soon after this time, when that Emperor\nobtained the kingdom for his eldest son Rodolph.  See Coxe\'s\nHouse of Austria, 4to.  ed. v. i. part 1. p. 87\n\nv. 117.  He.]  Philip IV of France, after the battle of Courtrai,\n1302, in which the French were defeated by the Flemings, raised\nthe nominal value of the coin.  This king died in consequence of\nhis horse being thrown to the ground by a wild boar, in 1314\n\nv. 121.  The English and Scot.]  He adverts");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "EQUATE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                size_t size = file_read(filecontent, 1, 2669, file);
                test_error(size == 2464, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2464 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 2464);

                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));

                onerror_compare_memory(expected_filecontent, filecontent, 2464);


                free(filecontent);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 16: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST16(void)
{
    // informacje o teście
    test_start(16, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char *filecontent = (char *)calloc(3960, 1);
                char expected_filecontent[3961] = "";

                strcat(expected_filecontent, "eyes glar\'d wheeling flames.  Meanwhile\nThose spirits, faint and naked, color chang\'d,\nAnd gnash\'d their teeth, soon as the cruel words\nThey heard.  God and their parents they blasphem\'d,\nThe human kind, the place, the time, and seed\nThat did engender them and give them birth.\n     Then all together sorely wailing drew\nTo the curs\'d strand, that every man must pass\nWho fears not God.  Charon, demoniac form,\nWith eyes of burning coal, collects them all,\nBeck\'ning, and each, that lingers, with his oar\nStrikes.  As fall off the light autumnal leaves,\nOne still another following, till the bough\nStrews all its honours on the earth beneath;\nE\'en in like manner Adam\'s evil brood\nCast themselves one by one down from the shore,\nEach at a beck, as falcon at his call.\n     Thus go they over through the umber\'d wave,\nAnd ever they on the opposing bank\nBe landed, on this side another throng\nStill gathers.  \"Son,\" thus spake the courteous guide,\n\"Those, who die subject to the wrath of God,\nAll here together come from every clime,\nAnd to o\'erpass the river are not loth:\nFor so heaven\'s justice goads them on, that fear\nIs turn\'d into desire.  Hence ne\'er hath past\nGood spirit.  If of thee Charon complain,\nNow mayst thou know the import of his words.\"\n     This said, the gloomy region trembling shook\nSo terribly, that yet with clammy dews\nFear chills my brow.  The sad earth gave a blast,\nThat, lightening, shot forth a vermilion flame,\nWhich all my senses conquer\'d quite, and I\nDown dropp\'d, as one with sudden slumber seiz\'d.\n\n\n\nCANTO IV\n\nBROKE the deep slumber in my brain a crash\nOf heavy thunder, that I shook myself,\nAs one by main force rous\'d.  Risen upright,\nMy rested eyes I mov\'d around, and search\'d\nWith fixed ken to know what place it was,\nWherein I stood.  For certain on the brink\nI found me of the lamentable vale,\nThe dread abyss, that joins a thund\'rous sound\nOf plaints innumerable.  Dark and deep,\nAnd thick with clouds o\'erspread, mine eye in vain\nExplor\'d its bottom, nor could aught discern.\n     \"Now let us to the blind world there beneath\nDescend;\" the bard began all pale of look:\n\"I go the first, and thou shalt follow next.\"\n     Then I his alter\'d hue perceiving, thus:\n\"How may I speed, if thou yieldest to dread,\nWho still art wont to comfort me in doubt?\"\n     He then:  \"The anguish of that race below\nWith pity stains my cheek, which thou for fear\nMistakest.  Let us on.  Our length of way\nUrges to haste.\"  Onward, this said, he mov\'d;\nAnd ent\'ring led me with him on the bounds\nOf the first circle, that surrounds th\' abyss.\nHere, as mine ear could note, no plaint was heard\nExcept of sighs, that made th\' eternal air\nTremble, not caus\'d by tortures, but from grief\nFelt by those multitudes, many and vast,\nOf men, women, and infants.  Then to me\nThe gentle guide:  \"Inquir\'st thou not what spirits\nAre these, which thou beholdest?  Ere thou pass\nFarther, I would thou know, that these of sin\nWere blameless; and if aught they merited,\nIt profits not, since baptism was not theirs,\nThe portal to thy faith.  If they before\nThe Gospel liv\'d, they serv\'d not God aright;\nAnd among such am I. For these defects,\nAnd for no other evil, we are lost;\nOnly so far afflicted, that we live\nDesiring without hope.\"  So grief assail\'d\nMy heart at hearing this, for well I knew\nSuspended in that Limbo many a soul\nOf mighty worth.  \"O tell me, sire rever\'d!\nTell me, my master!\"  I began through wish\nOf full assurance in that holy faith,\nWhich vanquishes all error; \"say, did e\'er\nAny, or through his own or other\'s merit,\nCome forth from thence, whom afterward was blest?\"\n     Piercing the secret purport of my speech,\nHe answer\'d: \"I was new to that estate,\nWhen I beheld a puissant one arrive\nAmongst us, with victorious trophy crown\'d.\nHe forth the shade of our first parent drew,\nAbel his child, and Noah righteous man,\nOf Moses lawgiver for faith approv\'d,\nOf patriarch Abraham, and David king,\nIsrael with his sire and ");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "WHEEL");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                size_t size = file_read(filecontent, 1, 4373, file);
                test_error(size == 3960, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 3960 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 3960);

                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));

                onerror_compare_memory(expected_filecontent, filecontent, 3960);


                free(filecontent);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 17: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST17(void)
{
    // informacje o teście
    test_start(17, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char *filecontent = (char *)calloc(34, 1);
                char expected_filecontent[35] = "";

                strcat(expected_filecontent, "stings the piteous only feel),\nSo ");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "MINEDESE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                size_t size = file_read(filecontent, 1, 224, file);
                test_error(size == 34, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 34 bajtów, a wczytała %lu", size);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 34);

                // jeśli jest, to raportuj błąd
                test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));

                onerror_compare_memory(expected_filecontent, filecontent, 34);


                free(filecontent);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 18: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST18(void)
{
    // informacje o teście
    test_start(18, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char expected_filecontent[2561] = "";

                strcat(expected_filecontent, "round, who shines with sister lamp\nTo his, that glisters yonder,\" and I show\'d\nThe sun.  \"Tis he, who through profoundest night\nOf he true dead has brought me, with this flesh\nAs true, that follows.  From that gloom the aid\nOf his sure comfort drew me on to climb,\nAnd climbing wind along this mountain-steep,\nWhich rectifies in you whate\'er the world\nMade crooked and deprav\'d I have his word,\nThat he will bear me company as far\nAs till I come where Beatrice dwells:\nBut there must leave me.  Virgil is that spirit,\nWho thus hath promis\'d,\"  and I pointed to him;\n\"The other is that shade, for whom so late\nYour realm, as he arose, exulting shook\nThrough every pendent cliff and rocky bound.\"\n\n\n\nCANTO XXIV\n\nOur journey was not slacken\'d by our talk,\nNor yet our talk by journeying.  Still we spake,\nAnd urg\'d our travel stoutly, like a ship\nWhen the wind sits astern.  The shadowy forms,\nThat seem\'d things dead and dead again, drew in\nAt their deep-delved orbs rare wonder of me,\nPerceiving I had life; and I my words\nContinued, and thus spake; \"He journeys up\nPerhaps more tardily then else he would,\nFor others\' sake.  But tell me, if thou know\'st,\nWhere is Piccarda?  Tell me, if I see\nAny of mark, among this multitude,\nWho eye me thus.\"--\"My sister (she for whom,\n\'Twixt beautiful and good I cannot say\nWhich name was fitter ) wears e\'en now her crown,\nAnd triumphs in Olympus.\"  Saying this,\nHe added: \"Since spare diet hath so worn\nOur semblance out, \'t is lawful here to name\nEach one .   This,\" and his finger then he rais\'d,\n\"Is Buonaggiuna,--Buonaggiuna, he\nOf Lucca: and that face beyond him, pierc\'d\nUnto a leaner fineness than the rest,\nHad keeping of the church: he was of Tours,\nAnd purges by wan abstinence away\nBolsena\'s eels and cups of muscadel.\"\n     He show\'d me many others, one by one,\nAnd all, as they were nam\'d, seem\'d well content;\nFor no dark gesture I discern\'d in any.\nI saw through hunger Ubaldino grind\nHis teeth on emptiness; and Boniface,\nThat wav\'d the crozier o\'er a num\'rous flock.\nI saw the Marquis, who tad time erewhile\nTo swill at Forli with less drought, yet so\nWas one ne\'er sated.  I howe\'er, like him,\nThat gazing \'midst a crowd, singles out one,\nSo singled him of Lucca; for methought\nWas none amongst them took such note of me.\nSomewhat I heard him whisper of Gentucca:\nThe sound was indistinct, and murmur\'d there,\nWhere justice, that so strips them, fix\'d her sting.\n     \"Spirit!\" said I, \"it seems as thou wouldst fain\nSpeak with me.  Let me hear thee.  Mutual wish\nTo converse prompts, which let us both");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "COVER.TXT");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                for (int i = 0; i < 2560; ++i)
                {
                    char c;
                    int res = file_read(&c, 1, 1, file);
                    test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                    test_error(c == expected_filecontent[i], "Funkcja file_read() powinna odczytać w kroku %d znak %c, a odczytała znak %c", i, expected_filecontent[i], c);
                }

                char c;
                int res = file_read(&c, 1, 1, file);
                test_error(res == 0, "Funkcja file_read() powinna zwrócić wartość 0, a zwróciła %d", res);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 19: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST19(void)
{
    // informacje o teście
    test_start(19, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char expected_filecontent[261] = "";

                strcat(expected_filecontent, "ere mark\'d I Helen, for whose sake so long\nThe time was fraught with evil; there the great\nAchilles, who with love fought to the end.\nParis I saw, and Tristan; and beside\nA thousand more he show\'d me, and by name\nPointed them out, whom love bereav\'d of life.\n ");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "OUT");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                for (int i = 0; i < 260; ++i)
                {
                    char c;
                    int res = file_read(&c, 1, 1, file);
                    test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                    test_error(c == expected_filecontent[i], "Funkcja file_read() powinna odczytać w kroku %d znak %c, a odczytała znak %c", i, expected_filecontent[i], c);
                }

                char c;
                int res = file_read(&c, 1, 1, file);
                test_error(res == 0, "Funkcja file_read() powinna zwrócić wartość 0, a zwróciła %d", res);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 20: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST20(void)
{
    // informacje o teście
    test_start(20, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char expected_filecontent[2635] = "";

                strcat(expected_filecontent, "  To shun\nAll human converse, here she with her slaves\nPlying her arts remain\'d, and liv\'d, and left\nHer body tenantless.  Thenceforth the tribes,\nWho round were scatter\'d, gath\'ring to that place\nAssembled; for its strength was great, enclos\'d\nOn all parts by the fen.  On those dead bones\nThey rear\'d themselves a city, for her sake,\nCalling it Mantua, who first chose the spot,\nNor ask\'d another omen for the name,\nWherein more numerous the people dwelt,\nEre Casalodi\'s madness by deceit\nWas wrong\'d of Pinamonte.  If thou hear\nHenceforth another origin assign\'d\nOf that my country, I forewarn thee now,\nThat falsehood none beguile thee of the truth.\"\n     I answer\'d:  \"Teacher, I conclude thy words\nSo certain, that all else shall be to me\nAs embers lacking life.  But now of these,\nWho here proceed, instruct me, if thou see\nAny that merit more especial note.\nFor thereon is my mind alone intent.\"\n     He straight replied:  \"That spirit, from whose cheek\nThe beard sweeps o\'er his shoulders brown, what time\nGraecia was emptied of her males, that scarce\nThe cradles were supplied, the seer was he\nIn Aulis, who with Calchas gave the sign\nWhen first to cut the cable.  Him they nam\'d\nEurypilus:  so sings my tragic strain,\nIn which majestic measure well thou know\'st,\nWho know\'st it all.  That other, round the loins\nSo slender of his shape, was Michael Scot,\nPractis\'d in ev\'ry slight of magic wile.\n     \"Guido Bonatti see:   Asdente mark,\nWho now were willing, he had tended still\nThe thread and cordwain; and too late repents.\n     \"See next the wretches, who the needle left,\nThe shuttle and the spindle, and became\nDiviners:  baneful witcheries they wrought\nWith images and herbs.  But onward now:\nFor now doth Cain with fork of thorns confine\nOn either hemisphere, touching the wave\nBeneath the towers of Seville.  Yesternight\nThe moon was round.  Thou mayst remember well:\nFor she good service did thee in the gloom\nOf the deep wood.\"  This said, both onward mov\'d.\n\n\n\nCANTO XXI\n\nTHUS we from bridge to bridge, with other talk,\nThe which my drama cares not to rehearse,\nPass\'d on; and to the summit reaching, stood\nTo view another gap, within the round\nOf Malebolge, other bootless pangs.\n     Marvelous darkness shadow\'d o\'er the place.\n     In the Venetians\' arsenal as boils\nThrough wintry months tenacious pitch, to smear\nTheir unsound vessels; for th\' inclement time\nSea-faring men restrains, and in that while\nHis bark one builds anew, another stops\nThe ribs of his, that hath made many a voyage;\nOne hammers at the prow, one at the poop;\nThis shapeth oars, that other cables twirls,\nThe mizen one repairs and main");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "OPERATE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                for (int i = 0; i < 2634; ++i)
                {
                    char c;
                    int res = file_read(&c, 1, 1, file);
                    test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                    test_error(c == expected_filecontent[i], "Funkcja file_read() powinna odczytać w kroku %d znak %c, a odczytała znak %c", i, expected_filecontent[i], c);
                }

                char c;
                int res = file_read(&c, 1, 1, file);
                test_error(res == 0, "Funkcja file_read() powinna zwrócić wartość 0, a zwróciła %d", res);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 21: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST21(void)
{
    // informacje o teście
    test_start(21, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char expected_filecontent[2465] = "";

                strcat(expected_filecontent, "nder Godfrey of Bouillon, (Maimbourg, Hist.\ndes Croisades, ed. Par. 1682. 12mo. t. i. p. 96.) but rather the\ntwo more celebrated heroes in the age of Charlemagne.  The\nformer, William l. of Orange, supposed to have been the founder\nof the present illustrious family of that name, died about 808,\naccording to Joseph de la Piser, Tableau de l\'Hist. des Princes\net Principante d\'Orange. Our countryman, Ordericus Vitalis,\nprofesses to give his true life, which had been misrepresented in\nthe songs of the itinerant bards.\"  Vulgo canitur a joculatoribus\nde illo, cantilena; sed jure praeferenda est relatio\nauthentica.\"  Eccl.  Hist.  in Duchesne, Hist.  Normann Script.\np.  508. The latter is better known by having been celebrated by\nAriosto, under the name of Rinaldo.\n\nv. 43.  Duke Godfey.]  Godfrey of Bouillon.\n\nv. 46.  Robert Guiscard.]  See Hell, Canto XXVIII. v. 12.\n\nv. 81.  The characters.]  Diligite justitiam qui judicatis\nterrarm. \"Love righteousness, ye that be judges of the earth \"\nWisdom of  Solomon, c. i. 1.\n\nv. 116.  That once more.]  \"That he may again drive out those who\nbuy and sell in the temple.\"\n\nv. 124.  Taking the bread away.]  \"Excommunication, or the\ninterdiction of the Eucharist, is now employed as a weapon of\nwarfare.\"\n\nv. 126.  That writest but to cancel.]  \"And thou, Pope Boniface,\nwho writest thy ecclesiastical censures for no other purpose than\nto be  paid for revoking them.\"\n\nv. 130.  To him.]  The coin of Florence was stamped with the\nimpression of John the Baptist.\n\nCANTO XIX\n\nv. 38.  Who turn\'d his compass.]  Compare Proverbs, c. viii.  27.\nAnd Milton, P. L. b. vii 224.\n\nv. 42.  The Word]  \"The divine nature still remained\nincomprehensible. Of this Lucifer was a proof; for had he\nthoroughly comprehended it, he would not have fallen.\"\n\nv. 108.  The Ethiop.]  Matt.  c. xii.  41.\n\nv. 112.  That volume.]  Rev. c. xx.  12.\n\nv. 114.  Albert.]  Purgatory, Canto VI.  v. 98.\n\nv. 116.  Prague.]  The eagle predicts the devastation of Bohemia\nby Albert, which happened soon after this time, when that Emperor\nobtained the kingdom for his eldest son Rodolph.  See Coxe\'s\nHouse of Austria, 4to.  ed. v. i. part 1. p. 87\n\nv. 117.  He.]  Philip IV of France, after the battle of Courtrai,\n1302, in which the French were defeated by the Flemings, raised\nthe nominal value of the coin.  This king died in consequence of\nhis horse being thrown to the ground by a wild boar, in 1314\n\nv. 121.  The English and Scot.]  He adverts");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "EQUATE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                for (int i = 0; i < 2464; ++i)
                {
                    char c;
                    int res = file_read(&c, 1, 1, file);
                    test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                    test_error(c == expected_filecontent[i], "Funkcja file_read() powinna odczytać w kroku %d znak %c, a odczytała znak %c", i, expected_filecontent[i], c);
                }

                char c;
                int res = file_read(&c, 1, 1, file);
                test_error(res == 0, "Funkcja file_read() powinna zwrócić wartość 0, a zwróciła %d", res);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 22: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST22(void)
{
    // informacje o teście
    test_start(22, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char expected_filecontent[3961] = "";

                strcat(expected_filecontent, "eyes glar\'d wheeling flames.  Meanwhile\nThose spirits, faint and naked, color chang\'d,\nAnd gnash\'d their teeth, soon as the cruel words\nThey heard.  God and their parents they blasphem\'d,\nThe human kind, the place, the time, and seed\nThat did engender them and give them birth.\n     Then all together sorely wailing drew\nTo the curs\'d strand, that every man must pass\nWho fears not God.  Charon, demoniac form,\nWith eyes of burning coal, collects them all,\nBeck\'ning, and each, that lingers, with his oar\nStrikes.  As fall off the light autumnal leaves,\nOne still another following, till the bough\nStrews all its honours on the earth beneath;\nE\'en in like manner Adam\'s evil brood\nCast themselves one by one down from the shore,\nEach at a beck, as falcon at his call.\n     Thus go they over through the umber\'d wave,\nAnd ever they on the opposing bank\nBe landed, on this side another throng\nStill gathers.  \"Son,\" thus spake the courteous guide,\n\"Those, who die subject to the wrath of God,\nAll here together come from every clime,\nAnd to o\'erpass the river are not loth:\nFor so heaven\'s justice goads them on, that fear\nIs turn\'d into desire.  Hence ne\'er hath past\nGood spirit.  If of thee Charon complain,\nNow mayst thou know the import of his words.\"\n     This said, the gloomy region trembling shook\nSo terribly, that yet with clammy dews\nFear chills my brow.  The sad earth gave a blast,\nThat, lightening, shot forth a vermilion flame,\nWhich all my senses conquer\'d quite, and I\nDown dropp\'d, as one with sudden slumber seiz\'d.\n\n\n\nCANTO IV\n\nBROKE the deep slumber in my brain a crash\nOf heavy thunder, that I shook myself,\nAs one by main force rous\'d.  Risen upright,\nMy rested eyes I mov\'d around, and search\'d\nWith fixed ken to know what place it was,\nWherein I stood.  For certain on the brink\nI found me of the lamentable vale,\nThe dread abyss, that joins a thund\'rous sound\nOf plaints innumerable.  Dark and deep,\nAnd thick with clouds o\'erspread, mine eye in vain\nExplor\'d its bottom, nor could aught discern.\n     \"Now let us to the blind world there beneath\nDescend;\" the bard began all pale of look:\n\"I go the first, and thou shalt follow next.\"\n     Then I his alter\'d hue perceiving, thus:\n\"How may I speed, if thou yieldest to dread,\nWho still art wont to comfort me in doubt?\"\n     He then:  \"The anguish of that race below\nWith pity stains my cheek, which thou for fear\nMistakest.  Let us on.  Our length of way\nUrges to haste.\"  Onward, this said, he mov\'d;\nAnd ent\'ring led me with him on the bounds\nOf the first circle, that surrounds th\' abyss.\nHere, as mine ear could note, no plaint was heard\nExcept of sighs, that made th\' eternal air\nTremble, not caus\'d by tortures, but from grief\nFelt by those multitudes, many and vast,\nOf men, women, and infants.  Then to me\nThe gentle guide:  \"Inquir\'st thou not what spirits\nAre these, which thou beholdest?  Ere thou pass\nFarther, I would thou know, that these of sin\nWere blameless; and if aught they merited,\nIt profits not, since baptism was not theirs,\nThe portal to thy faith.  If they before\nThe Gospel liv\'d, they serv\'d not God aright;\nAnd among such am I. For these defects,\nAnd for no other evil, we are lost;\nOnly so far afflicted, that we live\nDesiring without hope.\"  So grief assail\'d\nMy heart at hearing this, for well I knew\nSuspended in that Limbo many a soul\nOf mighty worth.  \"O tell me, sire rever\'d!\nTell me, my master!\"  I began through wish\nOf full assurance in that holy faith,\nWhich vanquishes all error; \"say, did e\'er\nAny, or through his own or other\'s merit,\nCome forth from thence, whom afterward was blest?\"\n     Piercing the secret purport of my speech,\nHe answer\'d: \"I was new to that estate,\nWhen I beheld a puissant one arrive\nAmongst us, with victorious trophy crown\'d.\nHe forth the shade of our first parent drew,\nAbel his child, and Noah righteous man,\nOf Moses lawgiver for faith approv\'d,\nOf patriarch Abraham, and David king,\nIsrael with his sire and ");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "WHEEL");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                for (int i = 0; i < 3960; ++i)
                {
                    char c;
                    int res = file_read(&c, 1, 1, file);
                    test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                    test_error(c == expected_filecontent[i], "Funkcja file_read() powinna odczytać w kroku %d znak %c, a odczytała znak %c", i, expected_filecontent[i], c);
                }

                char c;
                int res = file_read(&c, 1, 1, file);
                test_error(res == 0, "Funkcja file_read() powinna zwrócić wartość 0, a zwróciła %d", res);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 23: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST23(void)
{
    // informacje o teście
    test_start(23, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                char expected_filecontent[35] = "";

                strcat(expected_filecontent, "stings the piteous only feel),\nSo ");

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct file_t* file = file_open(volume, "MINEDESE");
                test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                for (int i = 0; i < 34; ++i)
                {
                    char c;
                    int res = file_read(&c, 1, 1, file);
                    test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                    test_error(c == expected_filecontent[i], "Funkcja file_read() powinna odczytać w kroku %d znak %c, a odczytała znak %c", i, expected_filecontent[i], c);
                }

                char c;
                int res = file_read(&c, 1, 1, file);
                test_error(res == 0, "Funkcja file_read() powinna zwrócić wartość 0, a zwróciła %d", res);

                file_close(file);
                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 24: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST24(void)
{
    // informacje o teście
    test_start(24, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
            char *filecontent = (char *)calloc(2634, 1);
            char expected_filecontent[2635] = "";

            strcat(expected_filecontent, "  To shun\nAll human converse, here she with her slaves\nPlying her arts remain\'d, and liv\'d, and left\nHer body tenantless.  Thenceforth the tribes,\nWho round were scatter\'d, gath\'ring to that place\nAssembled; for its strength was great, enclos\'d\nOn all parts by the fen.  On those dead bones\nThey rear\'d themselves a city, for her sake,\nCalling it Mantua, who first chose the spot,\nNor ask\'d another omen for the name,\nWherein more numerous the people dwelt,\nEre Casalodi\'s madness by deceit\nWas wrong\'d of Pinamonte.  If thou hear\nHenceforth another origin assign\'d\nOf that my country, I forewarn thee now,\nThat falsehood none beguile thee of the truth.\"\n     I answer\'d:  \"Teacher, I conclude thy words\nSo certain, that all else shall be to me\nAs embers lacking life.  But now of these,\nWho here proceed, instruct me, if thou see\nAny that merit more especial note.\nFor thereon is my mind alone intent.\"\n     He straight replied:  \"That spirit, from whose cheek\nThe beard sweeps o\'er his shoulders brown, what time\nGraecia was emptied of her males, that scarce\nThe cradles were supplied, the seer was he\nIn Aulis, who with Calchas gave the sign\nWhen first to cut the cable.  Him they nam\'d\nEurypilus:  so sings my tragic strain,\nIn which majestic measure well thou know\'st,\nWho know\'st it all.  That other, round the loins\nSo slender of his shape, was Michael Scot,\nPractis\'d in ev\'ry slight of magic wile.\n     \"Guido Bonatti see:   Asdente mark,\nWho now were willing, he had tended still\nThe thread and cordwain; and too late repents.\n     \"See next the wretches, who the needle left,\nThe shuttle and the spindle, and became\nDiviners:  baneful witcheries they wrought\nWith images and herbs.  But onward now:\nFor now doth Cain with fork of thorns confine\nOn either hemisphere, touching the wave\nBeneath the towers of Seville.  Yesternight\nThe moon was round.  Thou mayst remember well:\nFor she good service did thee in the gloom\nOf the deep wood.\"  This said, both onward mov\'d.\n\n\n\nCANTO XXI\n\nTHUS we from bridge to bridge, with other talk,\nThe which my drama cares not to rehearse,\nPass\'d on; and to the summit reaching, stood\nTo view another gap, within the round\nOf Malebolge, other bootless pangs.\n     Marvelous darkness shadow\'d o\'er the place.\n     In the Venetians\' arsenal as boils\nThrough wintry months tenacious pitch, to smear\nTheir unsound vessels; for th\' inclement time\nSea-faring men restrains, and in that while\nHis bark one builds anew, another stops\nThe ribs of his, that hath made many a voyage;\nOne hammers at the prow, one at the poop;\nThis shapeth oars, that other cables twirls,\nThe mizen one repairs and main");

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(volume, "OPERATE");
            test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            int i;
            for (i = 0; i < 329; ++i)
            {
                int res = file_read(filecontent + 8 * i, 8, 1, file);
                test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            }

            int res = file_read(filecontent + 8 * i, 8, 1, file);
            test_error(res == 0, "Funkcja file_read() powinna zwrócić wartość 0, a zwróciła %d", res);
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            int diff_pos = mem_find_first_difference(filecontent, expected_filecontent, 2634);

            // jeśli jest, to raportuj błąd
            test_error(diff_pos == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                diff_pos, mem_get_byte(filecontent, diff_pos), mem_get_byte(expected_filecontent, diff_pos));

            onerror_compare_memory(expected_filecontent, filecontent, 2634);

            free(filecontent);
            file_close(file);
            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 25: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST25(void)
{
    // informacje o teście
    test_start(25, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            char *filecontent0 = (char *)calloc(2560, 1);
    char *filecontent1 = (char *)calloc(260, 1);
    char *filecontent2 = (char *)calloc(2634, 1);
    char *filecontent3 = (char *)calloc(2464, 1);
    char *filecontent4 = (char *)calloc(3960, 1);
    char *filecontent5 = (char *)calloc(34, 1);

            char expected_filecontent0[2561] = "";
    char expected_filecontent1[261] = "";
    char expected_filecontent2[2635] = "";
    char expected_filecontent3[2465] = "";
    char expected_filecontent4[3961] = "";
    char expected_filecontent5[35] = "";

            strcat(expected_filecontent0, "round, who shines with sister lamp\nTo his, that glisters yonder,\" and I show\'d\nThe sun.  \"Tis he, who through profoundest night\nOf he true dead has brought me, with this flesh\nAs true, that follows.  From that gloom the aid\nOf his sure comfort drew me on to climb,\nAnd climbing wind along this mountain-steep,\nWhich rectifies in you whate\'er the world\nMade crooked and deprav\'d I have his word,\nThat he will bear me company as far\nAs till I come where Beatrice dwells:\nBut there must leave me.  Virgil is that spirit,\nWho thus hath promis\'d,\"  and I pointed to him;\n\"The other is that shade, for whom so late\nYour realm, as he arose, exulting shook\nThrough every pendent cliff and rocky bound.\"\n\n\n\nCANTO XXIV\n\nOur journey was not slacken\'d by our talk,\nNor yet our talk by journeying.  Still we spake,\nAnd urg\'d our travel stoutly, like a ship\nWhen the wind sits astern.  The shadowy forms,\nThat seem\'d things dead and dead again, drew in\nAt their deep-delved orbs rare wonder of me,\nPerceiving I had life; and I my words\nContinued, and thus spake; \"He journeys up\nPerhaps more tardily then else he would,\nFor others\' sake.  But tell me, if thou know\'st,\nWhere is Piccarda?  Tell me, if I see\nAny of mark, among this multitude,\nWho eye me thus.\"--\"My sister (she for whom,\n\'Twixt beautiful and good I cannot say\nWhich name was fitter ) wears e\'en now her crown,\nAnd triumphs in Olympus.\"  Saying this,\nHe added: \"Since spare diet hath so worn\nOur semblance out, \'t is lawful here to name\nEach one .   This,\" and his finger then he rais\'d,\n\"Is Buonaggiuna,--Buonaggiuna, he\nOf Lucca: and that face beyond him, pierc\'d\nUnto a leaner fineness than the rest,\nHad keeping of the church: he was of Tours,\nAnd purges by wan abstinence away\nBolsena\'s eels and cups of muscadel.\"\n     He show\'d me many others, one by one,\nAnd all, as they were nam\'d, seem\'d well content;\nFor no dark gesture I discern\'d in any.\nI saw through hunger Ubaldino grind\nHis teeth on emptiness; and Boniface,\nThat wav\'d the crozier o\'er a num\'rous flock.\nI saw the Marquis, who tad time erewhile\nTo swill at Forli with less drought, yet so\nWas one ne\'er sated.  I howe\'er, like him,\nThat gazing \'midst a crowd, singles out one,\nSo singled him of Lucca; for methought\nWas none amongst them took such note of me.\nSomewhat I heard him whisper of Gentucca:\nThe sound was indistinct, and murmur\'d there,\nWhere justice, that so strips them, fix\'d her sting.\n     \"Spirit!\" said I, \"it seems as thou wouldst fain\nSpeak with me.  Let me hear thee.  Mutual wish\nTo converse prompts, which let us both");strcat(expected_filecontent1, "ere mark\'d I Helen, for whose sake so long\nThe time was fraught with evil; there the great\nAchilles, who with love fought to the end.\nParis I saw, and Tristan; and beside\nA thousand more he show\'d me, and by name\nPointed them out, whom love bereav\'d of life.\n ");strcat(expected_filecontent2, "  To shun\nAll human converse, here she with her slaves\nPlying her arts remain\'d, and liv\'d, and left\nHer body tenantless.  Thenceforth the tribes,\nWho round were scatter\'d, gath\'ring to that place\nAssembled; for its strength was great, enclos\'d\nOn all parts by the fen.  On those dead bones\nThey rear\'d themselves a city, for her sake,\nCalling it Mantua, who first chose the spot,\nNor ask\'d another omen for the name,\nWherein more numerous the people dwelt,\nEre Casalodi\'s madness by deceit\nWas wrong\'d of Pinamonte.  If thou hear\nHenceforth another origin assign\'d\nOf that my country, I forewarn thee now,\nThat falsehood none beguile thee of the truth.\"\n     I answer\'d:  \"Teacher, I conclude thy words\nSo certain, that all else shall be to me\nAs embers lacking life.  But now of these,\nWho here proceed, instruct me, if thou see\nAny that merit more especial note.\nFor thereon is my mind alone intent.\"\n     He straight replied:  \"That spirit, from whose cheek\nThe beard sweeps o\'er his shoulders brown, what time\nGraecia was emptied of her males, that scarce\nThe cradles were supplied, the seer was he\nIn Aulis, who with Calchas gave the sign\nWhen first to cut the cable.  Him they nam\'d\nEurypilus:  so sings my tragic strain,\nIn which majestic measure well thou know\'st,\nWho know\'st it all.  That other, round the loins\nSo slender of his shape, was Michael Scot,\nPractis\'d in ev\'ry slight of magic wile.\n     \"Guido Bonatti see:   Asdente mark,\nWho now were willing, he had tended still\nThe thread and cordwain; and too late repents.\n     \"See next the wretches, who the needle left,\nThe shuttle and the spindle, and became\nDiviners:  baneful witcheries they wrought\nWith images and herbs.  But onward now:\nFor now doth Cain with fork of thorns confine\nOn either hemisphere, touching the wave\nBeneath the towers of Seville.  Yesternight\nThe moon was round.  Thou mayst remember well:\nFor she good service did thee in the gloom\nOf the deep wood.\"  This said, both onward mov\'d.\n\n\n\nCANTO XXI\n\nTHUS we from bridge to bridge, with other talk,\nThe which my drama cares not to rehearse,\nPass\'d on; and to the summit reaching, stood\nTo view another gap, within the round\nOf Malebolge, other bootless pangs.\n     Marvelous darkness shadow\'d o\'er the place.\n     In the Venetians\' arsenal as boils\nThrough wintry months tenacious pitch, to smear\nTheir unsound vessels; for th\' inclement time\nSea-faring men restrains, and in that while\nHis bark one builds anew, another stops\nThe ribs of his, that hath made many a voyage;\nOne hammers at the prow, one at the poop;\nThis shapeth oars, that other cables twirls,\nThe mizen one repairs and main");strcat(expected_filecontent3, "nder Godfrey of Bouillon, (Maimbourg, Hist.\ndes Croisades, ed. Par. 1682. 12mo. t. i. p. 96.) but rather the\ntwo more celebrated heroes in the age of Charlemagne.  The\nformer, William l. of Orange, supposed to have been the founder\nof the present illustrious family of that name, died about 808,\naccording to Joseph de la Piser, Tableau de l\'Hist. des Princes\net Principante d\'Orange. Our countryman, Ordericus Vitalis,\nprofesses to give his true life, which had been misrepresented in\nthe songs of the itinerant bards.\"  Vulgo canitur a joculatoribus\nde illo, cantilena; sed jure praeferenda est relatio\nauthentica.\"  Eccl.  Hist.  in Duchesne, Hist.  Normann Script.\np.  508. The latter is better known by having been celebrated by\nAriosto, under the name of Rinaldo.\n\nv. 43.  Duke Godfey.]  Godfrey of Bouillon.\n\nv. 46.  Robert Guiscard.]  See Hell, Canto XXVIII. v. 12.\n\nv. 81.  The characters.]  Diligite justitiam qui judicatis\nterrarm. \"Love righteousness, ye that be judges of the earth \"\nWisdom of  Solomon, c. i. 1.\n\nv. 116.  That once more.]  \"That he may again drive out those who\nbuy and sell in the temple.\"\n\nv. 124.  Taking the bread away.]  \"Excommunication, or the\ninterdiction of the Eucharist, is now employed as a weapon of\nwarfare.\"\n\nv. 126.  That writest but to cancel.]  \"And thou, Pope Boniface,\nwho writest thy ecclesiastical censures for no other purpose than\nto be  paid for revoking them.\"\n\nv. 130.  To him.]  The coin of Florence was stamped with the\nimpression of John the Baptist.\n\nCANTO XIX\n\nv. 38.  Who turn\'d his compass.]  Compare Proverbs, c. viii.  27.\nAnd Milton, P. L. b. vii 224.\n\nv. 42.  The Word]  \"The divine nature still remained\nincomprehensible. Of this Lucifer was a proof; for had he\nthoroughly comprehended it, he would not have fallen.\"\n\nv. 108.  The Ethiop.]  Matt.  c. xii.  41.\n\nv. 112.  That volume.]  Rev. c. xx.  12.\n\nv. 114.  Albert.]  Purgatory, Canto VI.  v. 98.\n\nv. 116.  Prague.]  The eagle predicts the devastation of Bohemia\nby Albert, which happened soon after this time, when that Emperor\nobtained the kingdom for his eldest son Rodolph.  See Coxe\'s\nHouse of Austria, 4to.  ed. v. i. part 1. p. 87\n\nv. 117.  He.]  Philip IV of France, after the battle of Courtrai,\n1302, in which the French were defeated by the Flemings, raised\nthe nominal value of the coin.  This king died in consequence of\nhis horse being thrown to the ground by a wild boar, in 1314\n\nv. 121.  The English and Scot.]  He adverts");strcat(expected_filecontent4, "eyes glar\'d wheeling flames.  Meanwhile\nThose spirits, faint and naked, color chang\'d,\nAnd gnash\'d their teeth, soon as the cruel words\nThey heard.  God and their parents they blasphem\'d,\nThe human kind, the place, the time, and seed\nThat did engender them and give them birth.\n     Then all together sorely wailing drew\nTo the curs\'d strand, that every man must pass\nWho fears not God.  Charon, demoniac form,\nWith eyes of burning coal, collects them all,\nBeck\'ning, and each, that lingers, with his oar\nStrikes.  As fall off the light autumnal leaves,\nOne still another following, till the bough\nStrews all its honours on the earth beneath;\nE\'en in like manner Adam\'s evil brood\nCast themselves one by one down from the shore,\nEach at a beck, as falcon at his call.\n     Thus go they over through the umber\'d wave,\nAnd ever they on the opposing bank\nBe landed, on this side another throng\nStill gathers.  \"Son,\" thus spake the courteous guide,\n\"Those, who die subject to the wrath of God,\nAll here together come from every clime,\nAnd to o\'erpass the river are not loth:\nFor so heaven\'s justice goads them on, that fear\nIs turn\'d into desire.  Hence ne\'er hath past\nGood spirit.  If of thee Charon complain,\nNow mayst thou know the import of his words.\"\n     This said, the gloomy region trembling shook\nSo terribly, that yet with clammy dews\nFear chills my brow.  The sad earth gave a blast,\nThat, lightening, shot forth a vermilion flame,\nWhich all my senses conquer\'d quite, and I\nDown dropp\'d, as one with sudden slumber seiz\'d.\n\n\n\nCANTO IV\n\nBROKE the deep slumber in my brain a crash\nOf heavy thunder, that I shook myself,\nAs one by main force rous\'d.  Risen upright,\nMy rested eyes I mov\'d around, and search\'d\nWith fixed ken to know what place it was,\nWherein I stood.  For certain on the brink\nI found me of the lamentable vale,\nThe dread abyss, that joins a thund\'rous sound\nOf plaints innumerable.  Dark and deep,\nAnd thick with clouds o\'erspread, mine eye in vain\nExplor\'d its bottom, nor could aught discern.\n     \"Now let us to the blind world there beneath\nDescend;\" the bard began all pale of look:\n\"I go the first, and thou shalt follow next.\"\n     Then I his alter\'d hue perceiving, thus:\n\"How may I speed, if thou yieldest to dread,\nWho still art wont to comfort me in doubt?\"\n     He then:  \"The anguish of that race below\nWith pity stains my cheek, which thou for fear\nMistakest.  Let us on.  Our length of way\nUrges to haste.\"  Onward, this said, he mov\'d;\nAnd ent\'ring led me with him on the bounds\nOf the first circle, that surrounds th\' abyss.\nHere, as mine ear could note, no plaint was heard\nExcept of sighs, that made th\' eternal air\nTremble, not caus\'d by tortures, but from grief\nFelt by those multitudes, many and vast,\nOf men, women, and infants.  Then to me\nThe gentle guide:  \"Inquir\'st thou not what spirits\nAre these, which thou beholdest?  Ere thou pass\nFarther, I would thou know, that these of sin\nWere blameless; and if aught they merited,\nIt profits not, since baptism was not theirs,\nThe portal to thy faith.  If they before\nThe Gospel liv\'d, they serv\'d not God aright;\nAnd among such am I. For these defects,\nAnd for no other evil, we are lost;\nOnly so far afflicted, that we live\nDesiring without hope.\"  So grief assail\'d\nMy heart at hearing this, for well I knew\nSuspended in that Limbo many a soul\nOf mighty worth.  \"O tell me, sire rever\'d!\nTell me, my master!\"  I began through wish\nOf full assurance in that holy faith,\nWhich vanquishes all error; \"say, did e\'er\nAny, or through his own or other\'s merit,\nCome forth from thence, whom afterward was blest?\"\n     Piercing the secret purport of my speech,\nHe answer\'d: \"I was new to that estate,\nWhen I beheld a puissant one arrive\nAmongst us, with victorious trophy crown\'d.\nHe forth the shade of our first parent drew,\nAbel his child, and Noah righteous man,\nOf Moses lawgiver for faith approv\'d,\nOf patriarch Abraham, and David king,\nIsrael with his sire and ");strcat(expected_filecontent5, "stings the piteous only feel),\nSo ");


            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            
                    struct file_t* file0 = file_open(volume, "COVER.TXT");
                    test_error(file0 != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)"

            
                    struct file_t* file1 = file_open(volume, "OUT");
                    test_error(file1 != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)"

            
                    struct file_t* file2 = file_open(volume, "OPERATE");
                    test_error(file2 != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)"

            
                    struct file_t* file3 = file_open(volume, "EQUATE");
                    test_error(file3 != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)"

            
                    struct file_t* file4 = file_open(volume, "WHEEL");
                    test_error(file4 != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)"

            
                    struct file_t* file5 = file_open(volume, "MINEDESE");
                    test_error(file5 != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
                    onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)"

            
            
                size_t size0 = file_read(filecontent0, 1, 2560, file0);
                test_error(size0 == 2560, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2560 bajtów, a wczytała %lu", size0);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                int diff_pos0 = mem_find_first_difference(filecontent0, expected_filecontent0, 2560);
        
                // jeśli jest, to raportuj błąd
                test_error(diff_pos0 == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos0, mem_get_byte(filecontent0, diff_pos0), mem_get_byte(expected_filecontent0, diff_pos0));
        
                onerror_compare_memory(expected_filecontent0, filecontent0, 2560);
            
                size_t size1 = file_read(filecontent1, 1, 260, file1);
                test_error(size1 == 260, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 260 bajtów, a wczytała %lu", size1);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                int diff_pos1 = mem_find_first_difference(filecontent1, expected_filecontent1, 260);
        
                // jeśli jest, to raportuj błąd
                test_error(diff_pos1 == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos1, mem_get_byte(filecontent1, diff_pos1), mem_get_byte(expected_filecontent1, diff_pos1));
        
                onerror_compare_memory(expected_filecontent1, filecontent1, 260);
            
                size_t size2 = file_read(filecontent2, 1, 2634, file2);
                test_error(size2 == 2634, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2634 bajtów, a wczytała %lu", size2);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                int diff_pos2 = mem_find_first_difference(filecontent2, expected_filecontent2, 2634);
        
                // jeśli jest, to raportuj błąd
                test_error(diff_pos2 == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos2, mem_get_byte(filecontent2, diff_pos2), mem_get_byte(expected_filecontent2, diff_pos2));
        
                onerror_compare_memory(expected_filecontent2, filecontent2, 2634);
            
                size_t size3 = file_read(filecontent3, 1, 2464, file3);
                test_error(size3 == 2464, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 2464 bajtów, a wczytała %lu", size3);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                int diff_pos3 = mem_find_first_difference(filecontent3, expected_filecontent3, 2464);
        
                // jeśli jest, to raportuj błąd
                test_error(diff_pos3 == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos3, mem_get_byte(filecontent3, diff_pos3), mem_get_byte(expected_filecontent3, diff_pos3));
        
                onerror_compare_memory(expected_filecontent3, filecontent3, 2464);
            
                size_t size4 = file_read(filecontent4, 1, 3960, file4);
                test_error(size4 == 3960, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 3960 bajtów, a wczytała %lu", size4);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                int diff_pos4 = mem_find_first_difference(filecontent4, expected_filecontent4, 3960);
        
                // jeśli jest, to raportuj błąd
                test_error(diff_pos4 == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos4, mem_get_byte(filecontent4, diff_pos4), mem_get_byte(expected_filecontent4, diff_pos4));
        
                onerror_compare_memory(expected_filecontent4, filecontent4, 3960);
            
                size_t size5 = file_read(filecontent5, 1, 34, file5);
                test_error(size5 == 34, "Funkcja file_read() niepoprawnie wczytała dane z pliku, powinna wczytać 34 bajtów, a wczytała %lu", size5);
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
                int diff_pos5 = mem_find_first_difference(filecontent5, expected_filecontent5, 34);
        
                // jeśli jest, to raportuj błąd
                test_error(diff_pos5 == -1, "Dane wczytane z pliku nie są poprawne; różnica w bajcie %d; jest 0x%02x a powinno być 0x%02x",
                    diff_pos5, mem_get_byte(filecontent5, diff_pos5), mem_get_byte(expected_filecontent5, diff_pos5));
        
                onerror_compare_memory(expected_filecontent5, filecontent5, 34);
            

            free(filecontent0);
    free(filecontent1);
    free(filecontent2);
    free(filecontent3);
    free(filecontent4);
    free(filecontent5);

            file_close(file0);
    file_close(file1);
    file_close(file2);
    file_close(file3);
    file_close(file4);
    file_close(file5);


            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 26: Sprawdzanie poprawności działania funkcji file_seek
//
void UTEST26(void)
{
    // informacje o teście
    test_start(26, "Sprawdzanie poprawności działania funkcji file_seek", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
            char *filecontent = (char *)calloc(3960, 1);
            char expected_filecontent[3961] = "";

            strcat(expected_filecontent, "eyes glar\'d wheeling flames.  Meanwhile\nThose spirits, faint and naked, color chang\'d,\nAnd gnash\'d their teeth, soon as the cruel words\nThey heard.  God and their parents they blasphem\'d,\nThe human kind, the place, the time, and seed\nThat did engender them and give them birth.\n     Then all together sorely wailing drew\nTo the curs\'d strand, that every man must pass\nWho fears not God.  Charon, demoniac form,\nWith eyes of burning coal, collects them all,\nBeck\'ning, and each, that lingers, with his oar\nStrikes.  As fall off the light autumnal leaves,\nOne still another following, till the bough\nStrews all its honours on the earth beneath;\nE\'en in like manner Adam\'s evil brood\nCast themselves one by one down from the shore,\nEach at a beck, as falcon at his call.\n     Thus go they over through the umber\'d wave,\nAnd ever they on the opposing bank\nBe landed, on this side another throng\nStill gathers.  \"Son,\" thus spake the courteous guide,\n\"Those, who die subject to the wrath of God,\nAll here together come from every clime,\nAnd to o\'erpass the river are not loth:\nFor so heaven\'s justice goads them on, that fear\nIs turn\'d into desire.  Hence ne\'er hath past\nGood spirit.  If of thee Charon complain,\nNow mayst thou know the import of his words.\"\n     This said, the gloomy region trembling shook\nSo terribly, that yet with clammy dews\nFear chills my brow.  The sad earth gave a blast,\nThat, lightening, shot forth a vermilion flame,\nWhich all my senses conquer\'d quite, and I\nDown dropp\'d, as one with sudden slumber seiz\'d.\n\n\n\nCANTO IV\n\nBROKE the deep slumber in my brain a crash\nOf heavy thunder, that I shook myself,\nAs one by main force rous\'d.  Risen upright,\nMy rested eyes I mov\'d around, and search\'d\nWith fixed ken to know what place it was,\nWherein I stood.  For certain on the brink\nI found me of the lamentable vale,\nThe dread abyss, that joins a thund\'rous sound\nOf plaints innumerable.  Dark and deep,\nAnd thick with clouds o\'erspread, mine eye in vain\nExplor\'d its bottom, nor could aught discern.\n     \"Now let us to the blind world there beneath\nDescend;\" the bard began all pale of look:\n\"I go the first, and thou shalt follow next.\"\n     Then I his alter\'d hue perceiving, thus:\n\"How may I speed, if thou yieldest to dread,\nWho still art wont to comfort me in doubt?\"\n     He then:  \"The anguish of that race below\nWith pity stains my cheek, which thou for fear\nMistakest.  Let us on.  Our length of way\nUrges to haste.\"  Onward, this said, he mov\'d;\nAnd ent\'ring led me with him on the bounds\nOf the first circle, that surrounds th\' abyss.\nHere, as mine ear could note, no plaint was heard\nExcept of sighs, that made th\' eternal air\nTremble, not caus\'d by tortures, but from grief\nFelt by those multitudes, many and vast,\nOf men, women, and infants.  Then to me\nThe gentle guide:  \"Inquir\'st thou not what spirits\nAre these, which thou beholdest?  Ere thou pass\nFarther, I would thou know, that these of sin\nWere blameless; and if aught they merited,\nIt profits not, since baptism was not theirs,\nThe portal to thy faith.  If they before\nThe Gospel liv\'d, they serv\'d not God aright;\nAnd among such am I. For these defects,\nAnd for no other evil, we are lost;\nOnly so far afflicted, that we live\nDesiring without hope.\"  So grief assail\'d\nMy heart at hearing this, for well I knew\nSuspended in that Limbo many a soul\nOf mighty worth.  \"O tell me, sire rever\'d!\nTell me, my master!\"  I began through wish\nOf full assurance in that holy faith,\nWhich vanquishes all error; \"say, did e\'er\nAny, or through his own or other\'s merit,\nCome forth from thence, whom afterward was blest?\"\n     Piercing the secret purport of my speech,\nHe answer\'d: \"I was new to that estate,\nWhen I beheld a puissant one arrive\nAmongst us, with victorious trophy crown\'d.\nHe forth the shade of our first parent drew,\nAbel his child, and Noah righteous man,\nOf Moses lawgiver for faith approv\'d,\nOf patriarch Abraham, and David king,\nIsrael with his sire and ");

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(volume, "WHEEL");
            test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            file_seek(file, 1329, SEEK_SET);
        
            char c;
            int res = file_read(&c, 1, 1, file);
            test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            test_error(expected_filecontent[1329] == c, "Funkcja file_read() powinna odczyatć z pliku wartość |%c|, a odczytała |%c|", expected_filecontent[1329], c);

            free(filecontent);
            file_close(file);
            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 27: Sprawdzanie poprawności działania funkcji file_seek
//
void UTEST27(void)
{
    // informacje o teście
    test_start(27, "Sprawdzanie poprawności działania funkcji file_seek", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
            char *filecontent = (char *)calloc(2560, 1);
            char expected_filecontent[2561] = "";

            strcat(expected_filecontent, "round, who shines with sister lamp\nTo his, that glisters yonder,\" and I show\'d\nThe sun.  \"Tis he, who through profoundest night\nOf he true dead has brought me, with this flesh\nAs true, that follows.  From that gloom the aid\nOf his sure comfort drew me on to climb,\nAnd climbing wind along this mountain-steep,\nWhich rectifies in you whate\'er the world\nMade crooked and deprav\'d I have his word,\nThat he will bear me company as far\nAs till I come where Beatrice dwells:\nBut there must leave me.  Virgil is that spirit,\nWho thus hath promis\'d,\"  and I pointed to him;\n\"The other is that shade, for whom so late\nYour realm, as he arose, exulting shook\nThrough every pendent cliff and rocky bound.\"\n\n\n\nCANTO XXIV\n\nOur journey was not slacken\'d by our talk,\nNor yet our talk by journeying.  Still we spake,\nAnd urg\'d our travel stoutly, like a ship\nWhen the wind sits astern.  The shadowy forms,\nThat seem\'d things dead and dead again, drew in\nAt their deep-delved orbs rare wonder of me,\nPerceiving I had life; and I my words\nContinued, and thus spake; \"He journeys up\nPerhaps more tardily then else he would,\nFor others\' sake.  But tell me, if thou know\'st,\nWhere is Piccarda?  Tell me, if I see\nAny of mark, among this multitude,\nWho eye me thus.\"--\"My sister (she for whom,\n\'Twixt beautiful and good I cannot say\nWhich name was fitter ) wears e\'en now her crown,\nAnd triumphs in Olympus.\"  Saying this,\nHe added: \"Since spare diet hath so worn\nOur semblance out, \'t is lawful here to name\nEach one .   This,\" and his finger then he rais\'d,\n\"Is Buonaggiuna,--Buonaggiuna, he\nOf Lucca: and that face beyond him, pierc\'d\nUnto a leaner fineness than the rest,\nHad keeping of the church: he was of Tours,\nAnd purges by wan abstinence away\nBolsena\'s eels and cups of muscadel.\"\n     He show\'d me many others, one by one,\nAnd all, as they were nam\'d, seem\'d well content;\nFor no dark gesture I discern\'d in any.\nI saw through hunger Ubaldino grind\nHis teeth on emptiness; and Boniface,\nThat wav\'d the crozier o\'er a num\'rous flock.\nI saw the Marquis, who tad time erewhile\nTo swill at Forli with less drought, yet so\nWas one ne\'er sated.  I howe\'er, like him,\nThat gazing \'midst a crowd, singles out one,\nSo singled him of Lucca; for methought\nWas none amongst them took such note of me.\nSomewhat I heard him whisper of Gentucca:\nThe sound was indistinct, and murmur\'d there,\nWhere justice, that so strips them, fix\'d her sting.\n     \"Spirit!\" said I, \"it seems as thou wouldst fain\nSpeak with me.  Let me hear thee.  Mutual wish\nTo converse prompts, which let us both");

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(volume, "COVER.TXT");
            test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            file_seek(file, -1842, SEEK_END);

            char c;
            int res = file_read(&c, 1, 1, file);
            test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            test_error(expected_filecontent[718] == c, "Funkcja file_read() powinna odczyatć z pliku wartość |%c|, a odczytała |%c|", expected_filecontent[718], c);

            free(filecontent);
            file_close(file);
            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 28: Sprawdzanie poprawności działania funkcji file_seek
//
void UTEST28(void)
{
    // informacje o teście
    test_start(28, "Sprawdzanie poprawności działania funkcji file_seek", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    
            char *filecontent = (char *)calloc(2464, 1);
            char expected_filecontent[2465] = "";

            strcat(expected_filecontent, "nder Godfrey of Bouillon, (Maimbourg, Hist.\ndes Croisades, ed. Par. 1682. 12mo. t. i. p. 96.) but rather the\ntwo more celebrated heroes in the age of Charlemagne.  The\nformer, William l. of Orange, supposed to have been the founder\nof the present illustrious family of that name, died about 808,\naccording to Joseph de la Piser, Tableau de l\'Hist. des Princes\net Principante d\'Orange. Our countryman, Ordericus Vitalis,\nprofesses to give his true life, which had been misrepresented in\nthe songs of the itinerant bards.\"  Vulgo canitur a joculatoribus\nde illo, cantilena; sed jure praeferenda est relatio\nauthentica.\"  Eccl.  Hist.  in Duchesne, Hist.  Normann Script.\np.  508. The latter is better known by having been celebrated by\nAriosto, under the name of Rinaldo.\n\nv. 43.  Duke Godfey.]  Godfrey of Bouillon.\n\nv. 46.  Robert Guiscard.]  See Hell, Canto XXVIII. v. 12.\n\nv. 81.  The characters.]  Diligite justitiam qui judicatis\nterrarm. \"Love righteousness, ye that be judges of the earth \"\nWisdom of  Solomon, c. i. 1.\n\nv. 116.  That once more.]  \"That he may again drive out those who\nbuy and sell in the temple.\"\n\nv. 124.  Taking the bread away.]  \"Excommunication, or the\ninterdiction of the Eucharist, is now employed as a weapon of\nwarfare.\"\n\nv. 126.  That writest but to cancel.]  \"And thou, Pope Boniface,\nwho writest thy ecclesiastical censures for no other purpose than\nto be  paid for revoking them.\"\n\nv. 130.  To him.]  The coin of Florence was stamped with the\nimpression of John the Baptist.\n\nCANTO XIX\n\nv. 38.  Who turn\'d his compass.]  Compare Proverbs, c. viii.  27.\nAnd Milton, P. L. b. vii 224.\n\nv. 42.  The Word]  \"The divine nature still remained\nincomprehensible. Of this Lucifer was a proof; for had he\nthoroughly comprehended it, he would not have fallen.\"\n\nv. 108.  The Ethiop.]  Matt.  c. xii.  41.\n\nv. 112.  That volume.]  Rev. c. xx.  12.\n\nv. 114.  Albert.]  Purgatory, Canto VI.  v. 98.\n\nv. 116.  Prague.]  The eagle predicts the devastation of Bohemia\nby Albert, which happened soon after this time, when that Emperor\nobtained the kingdom for his eldest son Rodolph.  See Coxe\'s\nHouse of Austria, 4to.  ed. v. i. part 1. p. 87\n\nv. 117.  He.]  Philip IV of France, after the battle of Courtrai,\n1302, in which the French were defeated by the Flemings, raised\nthe nominal value of the coin.  This king died in consequence of\nhis horse being thrown to the ground by a wild boar, in 1314\n\nv. 121.  The English and Scot.]  He adverts");

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(volume, "EQUATE");
            test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            file_seek(file, 908, SEEK_SET);
            file_seek(file, 408, SEEK_CUR);

            char c;
            int res = file_read(&c, 1, 1, file);
            test_error(res == 1, "Funkcja file_read() powinna zwrócić wartość 1, a zwróciła %d", res);
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            test_error(expected_filecontent[1316] == c, "Funkcja file_read() powinna odczyatć z pliku wartość |%c|, a odczytała |%c|", expected_filecontent[1316], c);

            free(filecontent);
            file_close(file);
            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 29: Sprawdzanie poprawności działania funkcji file_open
//
void UTEST29(void)
{
    // informacje o teście
    test_start(29, "Sprawdzanie poprawności działania funkcji file_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                 struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                 test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct volume_t* volume = fat_open(disk, 0);
                 test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct file_t* file = file_open(volume, "SOON");
                 test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL - nazwa podana w parametrze (SOON) jest nazwą katalogu, a nie pliku");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 fat_close(volume);
                 disk_close(disk);

                 test_no_heap_leakage();
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
             
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 30: Sprawdzanie poprawności działania funkcji file_open
//
void UTEST30(void)
{
    // informacje o teście
    test_start(30, "Sprawdzanie poprawności działania funkcji file_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                 struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                 test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct volume_t* volume = fat_open(disk, 0);
                 test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct file_t* file = file_open(volume, "WAVE");
                 test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL - nazwa podana w parametrze (WAVE) jest nazwą katalogu, a nie pliku");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 fat_close(volume);
                 disk_close(disk);

                 test_no_heap_leakage();
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
             
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 31: Sprawdzanie poprawności działania funkcji file_open
//
void UTEST31(void)
{
    // informacje o teście
    test_start(31, "Sprawdzanie poprawności działania funkcji file_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                 struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                 test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct volume_t* volume = fat_open(disk, 0);
                 test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct file_t* file = file_open(volume, "MOTION");
                 test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL - nazwa podana w parametrze (MOTION) jest nazwą katalogu, a nie pliku");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 fat_close(volume);
                 disk_close(disk);

                 test_no_heap_leakage();
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
             
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 32: Sprawdzanie poprawności działania funkcji file_open
//
void UTEST32(void)
{
    // informacje o teście
    test_start(32, "Sprawdzanie poprawności działania funkcji file_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                 struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                 test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct volume_t* volume = fat_open(disk, 0);
                 test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct file_t* file = file_open(volume, "SEVERAL");
                 test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL - nazwa podana w parametrze (SEVERAL) jest nazwą katalogu, a nie pliku");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 fat_close(volume);
                 disk_close(disk);

                 test_no_heap_leakage();
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
             
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 33: Sprawdzanie poprawności działania funkcji file_open
//
void UTEST33(void)
{
    // informacje o teście
    test_start(33, "Sprawdzanie poprawności działania funkcji file_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                 struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                 test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct volume_t* volume = fat_open(disk, 0);
                 test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct file_t* file = file_open(volume, "SEED");
                 test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL - nazwa podana w parametrze (SEED) jest nazwą katalogu, a nie pliku");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 fat_close(volume);
                 disk_close(disk);

                 test_no_heap_leakage();
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
             
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 34: Sprawdzanie poprawności działania funkcji file_open
//
void UTEST34(void)
{
    // informacje o teście
    test_start(34, "Sprawdzanie poprawności działania funkcji file_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                 struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                 test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct volume_t* volume = fat_open(disk, 0);
                 test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 struct file_t* file = file_open(volume, "PICTURED");
                 test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL - nazwa podana w parametrze (PICTURED) jest nazwą katalogu, a nie pliku");
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                 fat_close(volume);
                 disk_close(disk);

                 test_no_heap_leakage();
                 onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
             
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 35: Sprawdzanie poprawności działania funkcji file_open
//
void UTEST35(void)
{
    // informacje o teście
    test_start(35, "Sprawdzanie poprawności działania funkcji file_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(volume, "ONE.TX");
            test_error(file == NULL, "Funkcja file_open() nie powinna otworzyć pliku o nazwie ONE.TX, ponieważ nie istnieje on w katalogu głównym");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 36: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST36(void)
{
    // informacje o teście
    test_start(36, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(NULL, "ONE.TX");
            test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL w przypadku podania błędnych danych");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 37: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST37(void)
{
    // informacje o teście
    test_start(37, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(volume, NULL);
            test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL w przypadku podania błędnych danych");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 38: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST38(void)
{
    // informacje o teście
    test_start(38, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(NULL, NULL);
            test_error(file == NULL, "Funkcja file_open() powinna zwrócić NULL w przypadku podania błędnych danych");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 39: Sprawdzanie poprawności działania funkcji file_close
//
void UTEST39(void)
{
    // informacje o teście
    test_start(39, "Sprawdzanie poprawności działania funkcji file_close", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            file_close(NULL);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 40: Sprawdzanie poprawności działania funkcji file_read
//
void UTEST40(void)
{
    // informacje o teście
    test_start(40, "Sprawdzanie poprawności działania funkcji file_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct file_t* file = file_open(volume, "COVER.TXT");
            test_error(file != NULL, "Funkcja file_open() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            int res = file_read(NULL, 1, 1, file);
            test_error(res == -1, "Funkcja file_read() powinna zwrócić wartość -1, a zwróciła %d", res);
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            file_close(file);
            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 41: Sprawdzanie poprawności działania funkcji dir_read
//
void UTEST41(void)
{
    // informacje o teście
    test_start(41, "Sprawdzanie poprawności działania funkcji dir_read", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            char* expected_names[12] = { "COVER.TXT", "OUT", "OPERATE", "EQUATE", "WHEEL", "MINEDESE", "SOON", "WAVE", "MOTION", "SEVERAL", "SEED", "PICTURED" };
            int found_names[12] = { 0 };

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct dir_t* pdir = dir_open(volume, "\\");
            test_error(pdir != NULL, "Funkcja dir_open() niepoprawnie otworzyła katalog");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            for (int i = 0; i < 12; ++i)
            {
                struct dir_entry_t entry;
                int res = dir_read(pdir, &entry);
                test_error(res == 0, "Funkcja dir_read() niepoprawnie odczytała wpis z katalogu");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                int name_found = 0;

                for (int j = 0; j < 12; ++j)
                {
                    if (strcmp(entry.name, expected_names[j]) == 0)
                    {
                        test_error(found_names[j] == 0, "Funkcja dir_read() ponownie zwróciła informację o wpisie %s", expected_names[j]);
                        found_names[j] = 1;
                        name_found = 1;
                        break;
                    }
                }

                test_error(name_found == 1, "Funkcja dir_read() zwróciła informację o wpisie %s, który nie znajduje się w katalogu", entry.name);
            }

            struct dir_entry_t entry;
            int res = dir_read(pdir, &entry);
            test_error(res == 1, "Funkcja dir_read() zwróciła niepoprawną wartość, po odczytaniu wszystkich wpisów z katalogu powinna zwrócić %d, a zwróciła %d", 1, res);
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            dir_close(pdir);
            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 42: Sprawdzanie poprawności działania funkcji dir_open
//
void UTEST42(void)
{
    // informacje o teście
    test_start(42, "Sprawdzanie poprawności działania funkcji dir_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct dir_t*  dir = dir_open(volume, "COVER.TXT");
                test_error(dir == NULL, "Funkcja dir_open() powinna zwrócić NULL w przypadku podania niepoprawnej nazwy katalogu");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 43: Sprawdzanie poprawności działania funkcji dir_open
//
void UTEST43(void)
{
    // informacje o teście
    test_start(43, "Sprawdzanie poprawności działania funkcji dir_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct dir_t*  dir = dir_open(volume, "OUT");
                test_error(dir == NULL, "Funkcja dir_open() powinna zwrócić NULL w przypadku podania niepoprawnej nazwy katalogu");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 44: Sprawdzanie poprawności działania funkcji dir_open
//
void UTEST44(void)
{
    // informacje o teście
    test_start(44, "Sprawdzanie poprawności działania funkcji dir_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct dir_t*  dir = dir_open(volume, "OPERATE");
                test_error(dir == NULL, "Funkcja dir_open() powinna zwrócić NULL w przypadku podania niepoprawnej nazwy katalogu");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 45: Sprawdzanie poprawności działania funkcji dir_open
//
void UTEST45(void)
{
    // informacje o teście
    test_start(45, "Sprawdzanie poprawności działania funkcji dir_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct dir_t*  dir = dir_open(volume, "EQUATE");
                test_error(dir == NULL, "Funkcja dir_open() powinna zwrócić NULL w przypadku podania niepoprawnej nazwy katalogu");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 46: Sprawdzanie poprawności działania funkcji dir_open
//
void UTEST46(void)
{
    // informacje o teście
    test_start(46, "Sprawdzanie poprawności działania funkcji dir_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct dir_t*  dir = dir_open(volume, "WHEEL");
                test_error(dir == NULL, "Funkcja dir_open() powinna zwrócić NULL w przypadku podania niepoprawnej nazwy katalogu");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 47: Sprawdzanie poprawności działania funkcji dir_open
//
void UTEST47(void)
{
    // informacje o teście
    test_start(47, "Sprawdzanie poprawności działania funkcji dir_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

                struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
                test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct volume_t* volume = fat_open(disk, 0);
                test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                struct dir_t*  dir = dir_open(volume, "MINEDESE");
                test_error(dir == NULL, "Funkcja dir_open() powinna zwrócić NULL w przypadku podania niepoprawnej nazwy katalogu");
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

                fat_close(volume);
                disk_close(disk);

                test_no_heap_leakage();
                onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
            
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}

//
//  Test 48: Sprawdzanie poprawności działania funkcji dir_open
//
void UTEST48(void)
{
    // informacje o teście
    test_start(48, "Sprawdzanie poprawności działania funkcji dir_open", __LINE__);

    // uwarunkowanie zasobów - pamięci, itd...
    test_file_write_limit_setup(33554432);
    rldebug_reset_limits();
    
    //
    // -----------
    //
    

            struct disk_t* disk = disk_open_from_file("why_fat12_volume.img");
            test_error(disk != NULL, "Funkcja disk_open_from_file() niepoprawnie otworzyła plik");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct volume_t* volume = fat_open(disk, 0);
            test_error(volume != NULL, "Funkcja fat_open() niepoprawnie otworzyła wolumin");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            struct dir_t*  dir = dir_open(volume, "suit");
            test_error(dir == NULL, "Funkcja dir_open() powinna zwrócić NULL w przypadku podania niepoprawnej nazwy katalogu");
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)

            fat_close(volume);
            disk_close(disk);

            test_no_heap_leakage();
            onerror_terminate(); // przerwanie wszystkich testów jednostkowych (np. coś jest mocno nie tak z kodem)
        
    //
    // -----------
    //

    // przywrócenie podstawowych parametów przydzielania zasobów (jeśli to tylko możliwe)
    rldebug_reset_limits();
    test_file_write_limit_restore();
    
    test_ok();
}




enum run_mode_t { rm_normal_with_rld = 0, rm_unit_test = 1, rm_main_test = 2 };

int __wrap_main(volatile int _argc, char** _argv, char** _envp)
{
    int volatile vargc = _argc;
    char ** volatile vargv = _argv, ** volatile venvp = _envp;
	volatile enum run_mode_t run_mode = rm_unit_test; // -1
	volatile int selected_test = -1;

    if (vargc > 1)
	{
	    char* smode = strtok(vargv[1], ",");
	    char* stest = strtok(NULL, "");
		char *errptr = NULL;
		run_mode = (enum run_mode_t)strtol(smode, &errptr, 10);
		if (*errptr == '\x0')
		{
			memmove(vargv + 1, vargv + 2, sizeof(char*) * (vargc - 1));
			vargc--;

			if (stest != NULL)
			{
			    int val = (int)strtol(stest, &errptr, 10);
			    if (*errptr == '\x0')
			        selected_test = val;
			}
		}
	}

    // printf("runmode=%d; selected_test=%d\n", run_mode, selected_test);

    // inicjuj testy jednostkowe
    unit_test_init(run_mode, "unit_test_v2.c");
    test_limit_init();
    rldebug_set_reported_severity_level(MSL_FAILURE);

    if (run_mode == rm_normal_with_rld)
    {
        // konfiguracja ograniczników
        rldebug_reset_limits();
        

        // uruchom funkcję main Studenta a potem wyświetl podsumowanie sterty i zasobów
        volatile int ret_code = rdebug_call_main(tested_main, vargc, vargv, venvp);

        rldebug_reset_limits();
        

        int leaks_detected = rldebug_show_leaked_resources(0);
        if (leaks_detected)
            raise(SIGHEAP);

        return ret_code;
    }

    
    if (run_mode == rm_unit_test)
    {
        test_title("Testy jednostkowe");

        void (*pfcn[])(void) =
        { 
            UTEST1, // Sprawdzanie poprawności działania funkcji disk_open_from_file
            UTEST2, // Sprawdzanie poprawności działania funkcji disk_open_from_file
            UTEST3, // Sprawdzanie poprawności działania funkcji disk_close
            UTEST4, // Sprawdzanie poprawności działania funkcji fat_open
            UTEST5, // Sprawdzanie poprawności działania funkcji disk_open_from_file
            UTEST6, // Sprawdzanie poprawności działania funkcji file_read
            UTEST7, // Sprawdzanie poprawności działania funkcji file_read
            UTEST8, // Sprawdzanie poprawności działania funkcji file_read
            UTEST9, // Sprawdzanie poprawności działania funkcji file_read
            UTEST10, // Sprawdzanie poprawności działania funkcji file_read
            UTEST11, // Sprawdzanie poprawności działania funkcji file_read
            UTEST12, // Sprawdzanie poprawności działania funkcji file_read
            UTEST13, // Sprawdzanie poprawności działania funkcji file_read
            UTEST14, // Sprawdzanie poprawności działania funkcji file_read
            UTEST15, // Sprawdzanie poprawności działania funkcji file_read
            UTEST16, // Sprawdzanie poprawności działania funkcji file_read
            UTEST17, // Sprawdzanie poprawności działania funkcji file_read
            UTEST18, // Sprawdzanie poprawności działania funkcji file_read
            UTEST19, // Sprawdzanie poprawności działania funkcji file_read
            UTEST20, // Sprawdzanie poprawności działania funkcji file_read
            UTEST21, // Sprawdzanie poprawności działania funkcji file_read
            UTEST22, // Sprawdzanie poprawności działania funkcji file_read
            UTEST23, // Sprawdzanie poprawności działania funkcji file_read
            UTEST24, // Sprawdzanie poprawności działania funkcji file_read
            UTEST25, // Sprawdzanie poprawności działania funkcji file_read
            UTEST26, // Sprawdzanie poprawności działania funkcji file_seek
            UTEST27, // Sprawdzanie poprawności działania funkcji file_seek
            UTEST28, // Sprawdzanie poprawności działania funkcji file_seek
            UTEST29, // Sprawdzanie poprawności działania funkcji file_open
            UTEST30, // Sprawdzanie poprawności działania funkcji file_open
            UTEST31, // Sprawdzanie poprawności działania funkcji file_open
            UTEST32, // Sprawdzanie poprawności działania funkcji file_open
            UTEST33, // Sprawdzanie poprawności działania funkcji file_open
            UTEST34, // Sprawdzanie poprawności działania funkcji file_open
            UTEST35, // Sprawdzanie poprawności działania funkcji file_open
            UTEST36, // Sprawdzanie poprawności działania funkcji file_read
            UTEST37, // Sprawdzanie poprawności działania funkcji file_read
            UTEST38, // Sprawdzanie poprawności działania funkcji file_read
            UTEST39, // Sprawdzanie poprawności działania funkcji file_close
            UTEST40, // Sprawdzanie poprawności działania funkcji file_read
            UTEST41, // Sprawdzanie poprawności działania funkcji dir_read
            UTEST42, // Sprawdzanie poprawności działania funkcji dir_open
            UTEST43, // Sprawdzanie poprawności działania funkcji dir_open
            UTEST44, // Sprawdzanie poprawności działania funkcji dir_open
            UTEST45, // Sprawdzanie poprawności działania funkcji dir_open
            UTEST46, // Sprawdzanie poprawności działania funkcji dir_open
            UTEST47, // Sprawdzanie poprawności działania funkcji dir_open
            UTEST48, // Sprawdzanie poprawności działania funkcji dir_open
            NULL
        };

        for (int idx = 0; pfcn[idx] != NULL && !test_get_session_termination_flag(); idx++)
        {
            if (selected_test == -1 || selected_test == idx + 1)
                pfcn[idx]();

            // limit niezaliczonych testów, po jakim testy jednostkowe zostaną przerwane
            if (test_session_get_fail_count() >= 1000)
                test_terminate_session();
        }


        test_title("RLDebug :: Analiza wycieku zasobów");
        // sprawdź wycieki pamięci
        int leaks_detected = rldebug_show_leaked_resources(1);
        test_set_session_leaks(leaks_detected);

        // poinformuj serwer Mrówka o wyniku testu - podsumowanie
        test_title("Podsumowanie");
        if (selected_test == -1)
            test_summary(48); // wszystkie testy muszą zakończyć się sukcesem
        else
            test_summary(1); // tylko jeden (selected_test) test musi zakończyć się  sukcesem
        return EXIT_SUCCESS;
    }
    

    if (run_mode == rm_main_test)
    {
        test_title("Testy funkcji main()");

        void (*pfcn[])(int, char**, char**) =
        { 
            NULL
        };

        for (volatile int idx = 0; pfcn[idx] != NULL && !test_get_session_termination_flag(); idx++)
        {
            if (selected_test == -1 || selected_test == idx + 1)
                pfcn[idx](vargc, vargv, venvp);

            // limit niezaliczonych testów, po jakim testy jednostkowe zostaną przerwane
            if (test_session_get_fail_count() >= 1000)
                test_terminate_session();
        }


        test_title("RLDebug :: Analiza wycieku zasobów");
        // sprawdź wycieki pamięci
        int leaks_detected = rldebug_show_leaked_resources(1);
        test_set_session_leaks(leaks_detected);

        // poinformuj serwer Mrówka o wyniku testu - podsumowanie
        test_title("Podsumowanie");
        if (selected_test == -1)
            test_summary(0); // wszystkie testy muszą zakończyć się sukcesem
        else
            test_summary(1); // tylko jeden (selected_test) test musi zakończyć się  sukcesem

        return EXIT_SUCCESS;
    }

    printf("*** Nieznana wartość RunMode: %d", (int)run_mode);
    abort();
}