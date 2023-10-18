<div class="form-group dropdown filter-type-PriceRange">
    <a href="#" class="btn dropdown-toggle btn-block btn-default" data-toggle="dropdown" role="button" aria-expanded="false">
        <span class="name">Preisspanne</span>
        <span class="caret"></span>
    </a>
    <div class="dropdown-menu">
        
        <div class="PRwrapper">
                                    
            <div class="slider">
                <div class="progress"></div>
            </div>
            <div class="range-input">
                <input type="range" class="range-min" min="0" max="200" value="0" step="10">
                <input type="range" class="range-max" min="0" max="200" value="200" step="10">
            </div>
            <div class="price-input">
                <div class="field">
                    <input type="number" inputmode="numeric" pattern="[0-9]*" class="input-min" value="0">
                </div>
                <div class="separator">EUR</div>
                <div class="field">
                    <input type="number" inputmode="numeric" pattern="[0-9]*" class="input-max" value="200">
                </div>
            </div>
        </div>

        <ul class="nav nav-list blanklist PRbtnSubmit">
            <li><div class="alle-filtern btn btn-block btn-sm">Filter anwenden</div></li>
        </ul>

        <script defer>

            /* Klick auf den Preis-Ragne Submit-Button */
            $('.PRbtnSubmit').find('.alle-filtern').on('click', function(event) {
                event.preventDefault();
                event.stopPropagation();
                var curl = window.location.href;
                /* bereits aktiven PreisFilter entfernen */
                if(curl.indexOf('?pf=') != -1) { 
                curl = curl.split('?pf=');
                curl = curl[0];
                }
                curl = curl + '?pf=' + $('.PRwrapper').find('.input-min').val();
                curl = curl + '_' + $('.PRwrapper').find('.input-max').val();
                window.location.href = curl;
            });
            

            const rangeInput = document.querySelectorAll(".range-input input"),
            priceInput = document.querySelectorAll(".price-input input"),
            range = document.querySelector(".slider .progress");
            let priceGap = 10;
            priceInput.forEach((input) => {
                input.addEventListener("input", (e) => {
                    let minPrice = parseInt(priceInput[0].value),
                    maxPrice = parseInt(priceInput[1].value);
                    if (maxPrice - minPrice >= priceGap && maxPrice <= rangeInput[1].max) {
                        if (e.target.className === "input-min") {
                            rangeInput[0].value = minPrice;
                            range.style.left = (minPrice / rangeInput[0].max) * 100 + "%";
                        } else {
                            rangeInput[1].value = maxPrice;
                            range.style.right = 100 - (maxPrice / rangeInput[1].max) * 100 + "%";
                        }
                    }
                });
            });
            rangeInput.forEach((input) => {
                input.addEventListener("input", (e) => {
                    let minVal = parseInt(rangeInput[0].value),
                    maxVal = parseInt(rangeInput[1].value);
                    $('.PRbtnSubmit').slideDown();
                    if (maxVal - minVal < priceGap) {
                        if (e.target.className === "range-min") {
                            rangeInput[0].value = maxVal - priceGap;
                        } else {
                            rangeInput[1].value = minVal + priceGap;
                        }
                    } else {
                        priceInput[0].value = minVal;
                        priceInput[1].value = maxVal;
                        range.style.left = (minVal / rangeInput[0].max) * 100 + "%";
                        range.style.right = 100 - (maxVal / rangeInput[1].max) * 100 + "%";
                    }
                });
            });
            $(document).on('click', '.dropdown-menu', function (e) {
                e.stopPropagation();
            });

            if(window.location.href.indexOf('?pf=') != -1) {
                var valpf = window.location.href.split('?pf=');
                valpf = valpf[1].split('_');
                rangeInput[0].value = valpf[0];
                priceInput[0].value = valpf[0];
                rangeInput[1].value = valpf[1];
                priceInput[1].value = valpf[1];
            }

        </script>
        
    </div>
</div>