import { Component, input, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { faBars, faTimes } from '@fortawesome/free-solid-svg-icons';

export type NavLink = { path: string, label: string };

@Component({
  selector: 'min-url-header',
  standalone: true,
  imports: [RouterLink, FontAwesomeModule],
  templateUrl: './header.component.html'
})
export class HeaderComponent {
  links = input<NavLink[]>([
    { label: 'Encurtar', path: '/encurtar' },
    { label: 'Sobre', path: '/sobre' },
    { label: 'Funcionalidades', path: '/funcionalidades' },
    { label: 'Entrar', path: '/entrar' }
  ]);

  isMenuOpen = signal(false);

  faBars = faBars;
  faTimes = faTimes;

  toggleMenu() {
    this.isMenuOpen.set(!this.isMenuOpen());
  }

  closeMenu() {
    this.isMenuOpen.set(false);
  }
}
