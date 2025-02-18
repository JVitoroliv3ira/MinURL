import { Component } from '@angular/core';
import { HeaderComponent } from "../../../../layout/header/header.component";
import { FooterComponent } from "../../../../layout/footer/footer.component";
import { UrlShortenerSectionComponent } from "../../components/url-shortener-section/url-shortener-section.component";

@Component({
  selector: 'min-url-home',
  imports: [HeaderComponent, FooterComponent, UrlShortenerSectionComponent],
  templateUrl: './home.component.html'
})
export class HomeComponent {

}
