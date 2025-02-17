import { Component } from '@angular/core';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { faHeart } from '@fortawesome/free-solid-svg-icons';
import { faGithub, faLinkedin } from '@fortawesome/free-brands-svg-icons';

@Component({
  selector: 'min-url-footer',
  imports:  [FontAwesomeModule],
  templateUrl: './footer.component.html'
})
export class FooterComponent {
  faGithub = faGithub;
  faLinkedin = faLinkedin;
  faHeart = faHeart;
}
