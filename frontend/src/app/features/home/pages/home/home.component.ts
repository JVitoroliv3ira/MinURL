import { Component } from '@angular/core';
import { HeaderComponent } from "../../../../layout/header/header.component";
import { FooterComponent } from "../../../../layout/footer/footer.component";
import { UrlShortenerSectionComponent } from "../../components/url-shortener-section/url-shortener-section.component";
import { ShortenedUrlResultComponent } from "../../components/shortened-url-result/shortened-url-result.component";

@Component({
  selector: 'min-url-home',
  imports: [HeaderComponent, FooterComponent, UrlShortenerSectionComponent, ShortenedUrlResultComponent],
  templateUrl: './home.component.html'
})
export class HomeComponent {

}
