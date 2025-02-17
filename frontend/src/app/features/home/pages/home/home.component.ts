import { Component } from '@angular/core';
import { HeaderComponent } from "../../../../layout/header/header.component";
import { FooterComponent } from "../../../../layout/footer/footer.component";

@Component({
  selector: 'min-url-home',
  imports: [HeaderComponent, FooterComponent],
  templateUrl: './home.component.html'
})
export class HomeComponent {

}
